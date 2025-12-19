import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { getAuthContext, requireAdmin, UserRole } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import { ErrorMessages } from "../utils/validators";

/**
 * Assign Courier Function
 * Automatically assign a courier to a pickup request based on zone and availability
 *
 * Input:
 * - requestId: string
 * - preferredCourierId?: string (optional)
 *
 * Output:
 * - taskId: string
 * - courierId: string
 * - courierName: string
 * - otp: string
 */

interface AssignCourierRequest {
  requestId: string;
  preferredCourierId?: string;
}

interface AssignCourierResponse {
  taskId: string;
  courierId: string;
  courierName: string;
  otp: string;
  assignedAt: Date;
}

export const assignCourier = onCall<
  AssignCourierRequest,
  Promise<AssignCourierResponse>
>(async (request) => {
  // ============================================
  // AUTHENTICATION & AUTHORIZATION
  // ============================================
  const context = await getAuthContext(request);

  // Only admin can manually assign couriers
  requireAdmin(context);

  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { requestId, preferredCourierId } = request.data;

  if (!requestId || typeof requestId !== "string") {
    throw new HttpsError("invalid-argument", "Invalid request ID");
  }

  console.log(
    `Assign courier - Request: ${requestId}, Preferred: ${
      preferredCourierId || "auto"
    }`
  );

  // ============================================
  // GET PICKUP REQUEST
  // ============================================
  const requestDoc = await collections.pickupRequests().doc(requestId).get();

  if (!requestDoc.exists) {
    throw new HttpsError("not-found", "Pickup request not found");
  }

  const requestData = requestDoc.data();

  // Check if already assigned
  if (requestData?.status === "assigned" || requestData?.status === "done") {
    throw new HttpsError(
      "failed-precondition",
      "Pickup request already assigned or completed"
    );
  }

  // Get address to determine zone
  const addressId = requestData?.addressId;
  if (!addressId) {
    throw new HttpsError("invalid-argument", "Address ID missing from request");
  }

  const addressDoc = await collections.addresses().doc(addressId).get();
  if (!addressDoc.exists) {
    throw new HttpsError("not-found", "Address not found");
  }

  const addressData = addressDoc.data();
  const zoneId = determineZone(
    addressData?.latitude,
    addressData?.longitude,
    addressData?.city
  );

  console.log(`Pickup zone determined: ${zoneId}`);

  // ============================================
  // FIND AVAILABLE COURIER
  // ============================================
  let selectedCourierId: string;

  if (preferredCourierId) {
    // Use preferred courier if available
    const isAvailable = await isCourierAvailable(preferredCourierId);
    if (!isAvailable) {
      throw new HttpsError(
        "failed-precondition",
        "Preferred courier is not available"
      );
    }
    selectedCourierId = preferredCourierId;
  } else {
    // Auto-assign based on availability
    selectedCourierId = await findAvailableCourier(zoneId);
  }

  if (!selectedCourierId) {
    throw new HttpsError(
      "resource-exhausted",
      "No available couriers in the zone"
    );
  }

  // ============================================
  // GET COURIER INFO
  // ============================================
  const courierDoc = await collections.users().doc(selectedCourierId).get();
  if (!courierDoc.exists) {
    throw new HttpsError("not-found", "Courier not found");
  }

  const courierData = courierDoc.data();
  const courierName = courierData?.name || "Courier";

  // ============================================
  // CREATE PICKUP TASK
  // ============================================
  const otp = generateOTP();

  return runTransaction(async (transaction) => {
    // Create pickup task
    const taskRef = collections.pickupTasks().doc();
    const taskData = {
      requestId,
      courierId: selectedCourierId,
      status: "assigned",
      otp,
      assignedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    transaction.set(taskRef, taskData);

    // Update pickup request status
    transaction.update(collections.pickupRequests().doc(requestId), {
      status: "assigned",
      assignedCourierId: selectedCourierId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(
      `Task created - Task: ${taskRef.id}, Courier: ${selectedCourierId}`
    );

    // TODO: Send notification to courier
    // await sendCourierNotification(selectedCourierId, requestId, taskRef.id);

    return {
      taskId: taskRef.id,
      courierId: selectedCourierId,
      courierName,
      otp,
      assignedAt: new Date(),
    };
  });
});

/**
 * Auto-assign Courier Function (Triggered)
 * Automatically assign courier when pickup is confirmed
 * This can be triggered by Firestore onCreate or scheduled function
 *
 * Input:
 * - requestId: string
 *
 * Output:
 * - taskId: string
 * - courierId: string
 */

interface AutoAssignRequest {
  requestId: string;
}

interface AutoAssignResponse {
  taskId: string;
  courierId: string;
  success: boolean;
}

export const autoAssignCourier = onCall<
  AutoAssignRequest,
  Promise<AutoAssignResponse>
>(async (request) => {
  const { requestId } = request.data;

  if (!requestId) {
    throw new HttpsError("invalid-argument", "Request ID required");
  }

  console.log(`Auto-assign courier for request: ${requestId}`);

  // Get pickup request
  const requestDoc = await collections.pickupRequests().doc(requestId).get();

  if (!requestDoc.exists) {
    throw new HttpsError("not-found", "Request not found");
  }

  const requestData = requestDoc.data();

  // Only auto-assign if status is "confirmed"
  if (requestData?.status !== "confirmed") {
    throw new HttpsError(
      "failed-precondition",
      "Request must be confirmed before assignment"
    );
  }

  // Get zone from address
  const addressDoc = await collections
    .addresses()
    .doc(requestData.addressId)
    .get();

  if (!addressDoc.exists) {
    throw new HttpsError("not-found", "Address not found");
  }

  const addressData = addressDoc.data();
  const zoneId = determineZone(
    addressData?.latitude,
    addressData?.longitude,
    addressData?.city
  );

  // Find available courier
  const courierId = await findAvailableCourier(zoneId);

  if (!courierId) {
    // No courier available, leave in confirmed state
    console.warn(`No available courier for zone ${zoneId}`);
    throw new HttpsError(
      "resource-exhausted",
      "No available couriers at this time"
    );
  }

  // Create task
  const otp = generateOTP();

  return runTransaction(async (transaction) => {
    const taskRef = collections.pickupTasks().doc();

    transaction.set(taskRef, {
      requestId,
      courierId,
      status: "assigned",
      otp,
      assignedAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    transaction.update(collections.pickupRequests().doc(requestId), {
      status: "assigned",
      assignedCourierId: courierId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      taskId: taskRef.id,
      courierId,
      success: true,
    };
  });
});

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Determine zone from coordinates or city
 */
function determineZone(
  latitude?: number,
  longitude?: number,
  city?: string
): string {
  // Simple zone determination based on coordinates
  // In production, use proper geofencing/zone mapping

  if (latitude && longitude) {
    // Round to 2 decimals for zone grouping
    const zoneLat = Math.floor(latitude * 100) / 100;
    const zoneLng = Math.floor(longitude * 100) / 100;
    return `zone_${zoneLat}_${zoneLng}`;
  }

  // Fallback to city-based zones
  if (city) {
    return `zone_city_${city.toLowerCase().replace(/\s+/g, "_")}`;
  }

  return "zone_default";
}

/**
 * Find available courier in zone
 */
async function findAvailableCourier(zoneId: string): Promise<string | null> {
  console.log(`Finding available courier in zone: ${zoneId}`);

  // Query users with courier role
  // TODO: Add zone-based filtering and availability check
  const couriersSnapshot = await collections
    .users()
    .where("roles", "array-contains", UserRole.COURIER)
    .limit(10)
    .get();

  if (couriersSnapshot.empty) {
    console.warn("No couriers found in database");
    return null;
  }

  // Check availability for each courier
  for (const courierDoc of couriersSnapshot.docs) {
    const courierId = courierDoc.id;

    // Check if courier has active tasks
    const activeTasksSnapshot = await collections
      .pickupTasks()
      .where("courierId", "==", courierId)
      .where("status", "in", ["assigned", "on_the_way", "arrived", "picked_up"])
      .limit(5) // Max concurrent tasks
      .get();

    // Courier is available if they have fewer than 5 active tasks
    if (activeTasksSnapshot.size < 5) {
      console.log(
        `Found available courier: ${courierId} (${activeTasksSnapshot.size} active tasks)`
      );
      return courierId;
    }
  }

  console.warn("All couriers are busy");
  return null;
}

/**
 * Check if specific courier is available
 */
async function isCourierAvailable(courierId: string): Promise<boolean> {
  // Check if courier exists and has courier role
  const courierDoc = await collections.users().doc(courierId).get();

  if (!courierDoc.exists) {
    return false;
  }

  const courierData = courierDoc.data();
  const roles = courierData?.roles || [];

  if (!roles.includes(UserRole.COURIER)) {
    return false;
  }

  // Check active tasks count
  const activeTasksSnapshot = await collections
    .pickupTasks()
    .where("courierId", "==", courierId)
    .where("status", "in", ["assigned", "on_the_way", "arrived", "picked_up"])
    .get();

  return activeTasksSnapshot.size < 5; // Max 5 concurrent tasks
}

/**
 * Generate 6-digit OTP
 */
function generateOTP(): string {
  const otp = Math.floor(100000 + Math.random() * 900000);
  return otp.toString();
}

/**
 * Get Courier Statistics
 * Get courier performance and availability stats
 *
 * Input:
 * - courierId: string
 *
 * Output:
 * - statistics object
 */

interface GetCourierStatsRequest {
  courierId: string;
}

interface CourierStats {
  courierId: string;
  totalTasks: number;
  completedTasks: number;
  activeTasks: number;
  completionRate: number;
  averageRating?: number;
  isAvailable: boolean;
}

export const getCourierStats = onCall<
  GetCourierStatsRequest,
  Promise<CourierStats>
>(async (request) => {
  const context = await getAuthContext(request);
  requireAdmin(context);

  const { courierId } = request.data;

  if (!courierId) {
    throw new HttpsError("invalid-argument", "Courier ID required");
  }

  // Get all tasks
  const allTasksSnapshot = await collections
    .pickupTasks()
    .where("courierId", "==", courierId)
    .get();

  const totalTasks = allTasksSnapshot.size;

  // Count by status
  let completedTasks = 0;
  let activeTasks = 0;

  allTasksSnapshot.forEach((doc) => {
    const status = doc.data().status;
    if (status === "completed") {
      completedTasks++;
    } else if (
      ["assigned", "on_the_way", "arrived", "picked_up"].includes(status)
    ) {
      activeTasks++;
    }
  });

  const completionRate =
    totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;

  // Check availability
  const isAvailable = await isCourierAvailable(courierId);

  return {
    courierId,
    totalTasks,
    completedTasks,
    activeTasks,
    completionRate,
    isAvailable,
  };
});

/**
 * Reassign Task Function
 * Reassign a task to a different courier
 *
 * Input:
 * - taskId: string
 * - newCourierId: string
 * - reason?: string
 *
 * Output:
 * - success: boolean
 */

interface ReassignTaskRequest {
  taskId: string;
  newCourierId: string;
  reason?: string;
}

interface ReassignTaskResponse {
  success: boolean;
  oldCourierId: string;
  newCourierId: string;
  message: string;
}

export const reassignTask = onCall<
  ReassignTaskRequest,
  Promise<ReassignTaskResponse>
>(async (request) => {
  const context = await getAuthContext(request);
  requireAdmin(context);

  const { taskId, newCourierId, reason } = request.data;

  if (!taskId || !newCourierId) {
    throw new HttpsError(
      "invalid-argument",
      "Task ID and new courier ID required"
    );
  }

  // Check if new courier is available
  const isAvailable = await isCourierAvailable(newCourierId);
  if (!isAvailable) {
    throw new HttpsError("failed-precondition", "New courier is not available");
  }

  return runTransaction(async (transaction) => {
    const taskRef = collections.pickupTasks().doc(taskId);
    const taskDoc = await transaction.get(taskRef);

    if (!taskDoc.exists) {
      throw new HttpsError("not-found", "Task not found");
    }

    const taskData = taskDoc.data();
    const oldCourierId = taskData?.courierId;

    // Can only reassign if not completed
    if (taskData?.status === "completed") {
      throw new HttpsError(
        "failed-precondition",
        "Cannot reassign completed task"
      );
    }

    // Update task
    transaction.update(taskRef, {
      courierId: newCourierId,
      previousCourierId: oldCourierId,
      reassignedAt: admin.firestore.FieldValue.serverTimestamp(),
      reassignReason: reason || "Reassigned by admin",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Update request
    const requestId = taskData?.requestId;
    if (requestId) {
      transaction.update(collections.pickupRequests().doc(requestId), {
        assignedCourierId: newCourierId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    return {
      success: true,
      oldCourierId,
      newCourierId,
      message: "Task reassigned successfully",
    };
  });
});
