import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {
  getAuthContext,
  requireAnyRole,
  UserRole,
  isOwner,
} from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import {
  PickupTaskStatus,
  isValidTaskStatusTransition,
  isValidOTP,
  ErrorMessages,
} from "../utils/validators";

/**
 * Update Task Status Function
 * Update pickup task status with validation and points calculation
 *
 * Flow:
 * assigned → on_the_way → arrived → picked_up → completed
 *
 * When status changes to "picked_up" or "completed":
 * - Calculate points from actual weight
 * - Write to point_ledger
 * - Update user points balance
 * - Send notification
 */

interface UpdateTaskStatusRequest {
  taskId: string;
  newStatus: PickupTaskStatus;
  otp?: string; // Required for picked_up/completed
  proof?: {
    photoUrls: string[];
    actualWeightKg: number;
    notes?: string;
  };
  location?: {
    latitude: number;
    longitude: number;
  };
  notes?: string;
}

interface UpdateTaskStatusResponse {
  success: boolean;
  taskId: string;
  newStatus: string;
  pointsAwarded?: number;
  message: string;
}

export const updateTaskStatus = onCall<
  UpdateTaskStatusRequest,
  Promise<UpdateTaskStatusResponse>
>(async (request) => {
  // ============================================
  // AUTHENTICATION & AUTHORIZATION
  // ============================================
  const context = await getAuthContext(request);

  // Only courier or admin can update task status
  requireAnyRole(context, [UserRole.COURIER, UserRole.ADMIN]);

  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { taskId, newStatus, otp, proof, location, notes } = request.data;

  if (!taskId || typeof taskId !== "string") {
    throw new HttpsError("invalid-argument", "Invalid task ID");
  }

  if (!newStatus || !Object.values(PickupTaskStatus).includes(newStatus)) {
    throw new HttpsError("invalid-argument", "Invalid status");
  }

  console.log(
    `Update task status - Task: ${taskId}, New status: ${newStatus}, User: ${context.uid}`
  );

  // ============================================
  // VALIDATE OTP FOR PICKUP/COMPLETION
  // ============================================
  if (
    (newStatus === PickupTaskStatus.PICKED_UP ||
      newStatus === PickupTaskStatus.COMPLETED) &&
    !otp
  ) {
    throw new HttpsError(
      "invalid-argument",
      "OTP is required for picked_up or completed status"
    );
  }

  if (otp && !isValidOTP(otp)) {
    throw new HttpsError("invalid-argument", "Invalid OTP format");
  }

  // ============================================
  // VALIDATE PROOF FOR COMPLETION
  // ============================================
  if (
    newStatus === PickupTaskStatus.COMPLETED &&
    (!proof || !proof.photoUrls || proof.photoUrls.length === 0)
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Proof with photos is required for completion"
    );
  }

  if (proof && (!proof.actualWeightKg || proof.actualWeightKg <= 0)) {
    throw new HttpsError(
      "invalid-argument",
      "Valid actual weight is required in proof"
    );
  }

  // ============================================
  // GET TASK AND VALIDATE
  // ============================================
  const taskDoc = await collections.pickupTasks().doc(taskId).get();

  if (!taskDoc.exists) {
    throw new HttpsError("not-found", "Task not found");
  }

  const taskData = taskDoc.data();
  const currentStatus = taskData?.status as PickupTaskStatus;
  const courierId = taskData?.courierId;
  const requestId = taskData?.requestId;
  const taskOtp = taskData?.otp;

  // Check ownership (courier must own the task)
  if (!isOwner(context, courierId) && !context.roles.includes(UserRole.ADMIN)) {
    throw new HttpsError(
      "permission-denied",
      "You are not assigned to this task"
    );
  }

  // Validate status transition
  if (!isValidTaskStatusTransition(currentStatus, newStatus)) {
    throw new HttpsError(
      "failed-precondition",
      `Invalid status transition from ${currentStatus} to ${newStatus}`
    );
  }

  // Validate OTP if provided
  if (otp && otp !== taskOtp) {
    throw new HttpsError("invalid-argument", "Invalid OTP");
  }

  // ============================================
  // VALIDATE LOCATION FOR ARRIVAL/PICKUP
  // ============================================
  if (
    (newStatus === PickupTaskStatus.ARRIVED ||
      newStatus === PickupTaskStatus.PICKED_UP) &&
    location
  ) {
    // TODO: Validate courier is within geofence of pickup location
    const isWithinGeofence = await validateGeofence(
      requestId,
      location.latitude,
      location.longitude
    );

    if (!isWithinGeofence) {
      console.warn(
        `Courier ${context.uid} is outside geofence for task ${taskId}`
      );
      // For now, just log warning. In production, might want to enforce this
    }
  }

  // ============================================
  // UPDATE TASK STATUS
  // ============================================
  return runTransaction(async (transaction) => {
    const taskRef = collections.pickupTasks().doc(taskId);

    // Prepare update data
    const updateData: any = {
      status: newStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // Set timestamp based on status
    switch (newStatus) {
      case PickupTaskStatus.ON_THE_WAY:
        updateData.startedAt = admin.firestore.FieldValue.serverTimestamp();
        break;
      case PickupTaskStatus.ARRIVED:
        updateData.arrivedAt = admin.firestore.FieldValue.serverTimestamp();
        break;
      case PickupTaskStatus.PICKED_UP:
        updateData.pickedUpAt = admin.firestore.FieldValue.serverTimestamp();
        break;
      case PickupTaskStatus.COMPLETED:
        updateData.completedAt = admin.firestore.FieldValue.serverTimestamp();
        break;
    }

    // Add proof if provided
    if (proof) {
      updateData.proof = {
        photoUrls: proof.photoUrls,
        actualWeightKg: proof.actualWeightKg,
        notes: proof.notes,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
    }

    // Add notes if provided
    if (notes) {
      updateData.notes = notes;
    }

    // Update task
    transaction.update(taskRef, updateData);

    // Update request status
    const requestRef = collections.pickupRequests().doc(requestId);
    const requestDoc = await transaction.get(requestRef);

    if (!requestDoc.exists) {
      throw new HttpsError("not-found", "Pickup request not found");
    }

    const requestData = requestDoc.data();

    // Update request status based on task status
    let requestStatus = requestData?.status;
    if (newStatus === PickupTaskStatus.COMPLETED) {
      requestStatus = "done";
    }

    transaction.update(requestRef, {
      status: requestStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // ============================================
    // CALCULATE AND AWARD POINTS
    // ============================================
    let pointsAwarded = 0;

    if (
      newStatus === PickupTaskStatus.COMPLETED ||
      newStatus === PickupTaskStatus.PICKED_UP
    ) {
      if (proof?.actualWeightKg) {
        // Get user ID from request
        const userId = requestData?.uid;

        if (!userId) {
          throw new HttpsError("internal", "User ID not found in request");
        }

        // Get user to check membership multiplier
        const userDoc = await transaction.get(collections.users().doc(userId));
        const userData = userDoc.data();
        const memberStatus = userData?.member?.status || "none";

        // Get membership multiplier
        const multiplier = getMembershipMultiplier(memberStatus);

        // Calculate points from quantities and actual weight
        const quantities = requestData?.quantities || {};
        const estWeightKg = requestData?.estWeightKg || 0;

        pointsAwarded = await calculatePoints(
          quantities,
          proof.actualWeightKg,
          estWeightKg,
          multiplier,
          transaction
        );

        console.log(
          `Points calculation - User: ${userId}, Weight: ${proof.actualWeightKg}kg, Multiplier: ${multiplier}x, Points: ${pointsAwarded}`
        );

        // Write to point ledger
        const ledgerRef = collections.pointLedger().doc();
        transaction.set(ledgerRef, {
          uid: userId,
          delta: pointsAwarded,
          reason: "pickup",
          refId: requestId,
          description: `Pickup completed - ${proof.actualWeightKg}kg waste collected`,
          metadata: {
            taskId,
            courierId: context.uid,
            actualWeightKg: proof.actualWeightKg,
            quantities,
          },
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        // Update user points balance
        const userRef = collections.users().doc(userId);
        transaction.update(userRef, {
          "points.balance": admin.firestore.FieldValue.increment(pointsAwarded),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        // TODO: Send notification to user
        // await sendPointsNotification(userId, pointsAwarded, requestId);
      }
    }

    return {
      success: true,
      taskId,
      newStatus,
      pointsAwarded: pointsAwarded > 0 ? pointsAwarded : undefined,
      message: `Task status updated to ${newStatus}${
        pointsAwarded > 0 ? `. ${pointsAwarded} points awarded.` : ""
      }`,
    };
  });
});

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Get membership multiplier
 */
function getMembershipMultiplier(memberStatus: string): number {
  const multipliers: Record<string, number> = {
    none: 1.0,
    basic: 1.0,
    silver: 1.2,
    gold: 1.5,
    platinum: 2.0,
  };

  return multipliers[memberStatus] || 1.0;
}

/**
 * Calculate points from quantities and weight
 */
async function calculatePoints(
  quantities: Record<string, number>,
  actualWeightKg: number,
  estWeightKg: number,
  multiplier: number,
  transaction: admin.firestore.Transaction
): Promise<number> {
  // Get pickup rates from Firestore
  const ratesSnapshot = await transaction.get(collections.pickupRates());

  const rates: Record<string, number> = {};

  ratesSnapshot.docs.forEach((doc) => {
    const category = doc.id;
    const pointRate = doc.data().pointRate || 0;
    rates[category] = pointRate;
  });

  // Calculate base points from categories
  let basePoints = 0;

  for (const [category, quantity] of Object.entries(quantities)) {
    const rate = rates[category] || 100; // Default 100 points/kg
    const avgWeight = 0.5; // Default avg weight per unit (kg)

    // Points = quantity * avgWeight * rate
    basePoints += quantity * avgWeight * rate;
  }

  // Adjust for actual weight vs estimated weight
  const weightRatio = estWeightKg > 0 ? actualWeightKg / estWeightKg : 1;
  const adjustedPoints = basePoints * weightRatio;

  // Apply membership multiplier
  const finalPoints = Math.round(adjustedPoints * multiplier);

  return finalPoints;
}

/**
 * Validate courier is within geofence of pickup location
 */
async function validateGeofence(
  requestId: string,
  courierLat: number,
  courierLng: number
): Promise<boolean> {
  const GEOFENCE_RADIUS_METERS = 100; // 100 meters threshold

  // Get pickup request
  const requestDoc = await collections.pickupRequests().doc(requestId).get();

  if (!requestDoc.exists) {
    return false;
  }

  const addressId = requestDoc.data()?.addressId;

  if (!addressId) {
    return false;
  }

  // Get address coordinates
  const addressDoc = await collections.addresses().doc(addressId).get();

  if (!addressDoc.exists) {
    return false;
  }

  const addressData = addressDoc.data();
  const addressLat = addressData?.latitude;
  const addressLng = addressData?.longitude;

  if (!addressLat || !addressLng) {
    return false;
  }

  // Calculate distance using Haversine formula
  const distance = calculateDistance(
    courierLat,
    courierLng,
    addressLat,
    addressLng
  );

  console.log(
    `Geofence check - Distance: ${distance.toFixed(
      2
    )}m, Threshold: ${GEOFENCE_RADIUS_METERS}m`
  );

  return distance <= GEOFENCE_RADIUS_METERS;
}

/**
 * Calculate distance between two coordinates (Haversine formula)
 */
function calculateDistance(
  lat1: number,
  lng1: number,
  lat2: number,
  lng2: number
): number {
  const R = 6371000; // Earth's radius in meters
  const dLat = toRadians(lat2 - lat1);
  const dLng = toRadians(lng2 - lng1);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) *
      Math.cos(toRadians(lat2)) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in meters
}

function toRadians(degrees: number): number {
  return degrees * (Math.PI / 180);
}

/**
 * Verify OTP Function
 * Separate function for OTP verification
 */

interface VerifyOTPRequest {
  taskId: string;
  otp: string;
}

interface VerifyOTPResponse {
  valid: boolean;
  taskId: string;
  message: string;
}

export const verifyOTP = onCall<VerifyOTPRequest, Promise<VerifyOTPResponse>>(
  async (request) => {
    const { taskId, otp } = request.data;

    if (!taskId || !otp) {
      throw new HttpsError("invalid-argument", "Task ID and OTP required");
    }

    if (!isValidOTP(otp)) {
      throw new HttpsError("invalid-argument", "Invalid OTP format");
    }

    // Get task
    const taskDoc = await collections.pickupTasks().doc(taskId).get();

    if (!taskDoc.exists) {
      throw new HttpsError("not-found", "Task not found");
    }

    const taskData = taskDoc.data();
    const taskOtp = taskData?.otp;

    const valid = otp === taskOtp;

    return {
      valid,
      taskId,
      message: valid ? "OTP verified" : "Invalid OTP",
    };
  }
);
