import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { getAuthContext, requireAuth } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import {
  isPositiveNumber,
  isValidUid,
  ErrorMessages,
} from "../utils/validators";
import {
  withIdempotency,
  generateReserveSlotKey,
  IdempotentOperations,
} from "../utils/idempotency";

/**
 * Reserve Slot Function
 * Atomically check slot capacity and reserve space for pickup
 *
 * Input:
 * - slotId: string
 * - estWeightKg: number
 * - requestId?: string (optional, for linking)
 *
 * Output:
 * - ok: boolean
 * - message: string
 * - availableWeightKg?: number
 */

interface ReserveSlotRequest {
  slotId: string;
  estWeightKg: number;
  requestId?: string;
}

interface ReserveSlotResponse {
  ok: boolean;
  message: string;
  availableWeightKg?: number;
  slotDetails?: {
    date: Date;
    startTime: string;
    endTime: string;
    capacityWeightKg: number;
    usedWeightKg: number;
  };
}

export const reserveSlot = onCall<
  ReserveSlotRequest,
  Promise<ReserveSlotResponse>
>(async (request) => {
  // ============================================
  // AUTHENTICATION
  // ============================================
  const uid = requireAuth(request);
  const context = await getAuthContext(request);

  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { slotId, estWeightKg, requestId } = request.data;

  if (!slotId || typeof slotId !== "string") {
    throw new HttpsError("invalid-argument", "Invalid slot ID");
  }

  if (!isPositiveNumber(estWeightKg)) {
    throw new HttpsError(
      "invalid-argument",
      "Estimated weight must be positive"
    );
  }

  if (estWeightKg > 1000) {
    throw new HttpsError(
      "invalid-argument",
      "Estimated weight exceeds maximum (1000kg)"
    );
  }

  console.log(
    `Reserve slot request - User: ${uid}, Slot: ${slotId}, Weight: ${estWeightKg}kg`
  );

  // ============================================
  // IDEMPOTENCY CHECK
  // ============================================
  const idempotencyKey = generateReserveSlotKey(uid, slotId);

  return withIdempotency<ReserveSlotResponse>(
    idempotencyKey,
    uid,
    IdempotentOperations.RESERVE_SLOT,
    async () => {
      // ============================================
      // ATOMIC TRANSACTION
      // ============================================
      return runTransaction(async (transaction) => {
        // Get slot document
        const slotRef = collections.pickupSlots().doc(slotId);
        const slotDoc = await transaction.get(slotRef);

        if (!slotDoc.exists) {
          throw new HttpsError("not-found", ErrorMessages.RESOURCE_NOT_FOUND);
        }

        const slotData = slotDoc.data();

        // Check if slot is active
        if (slotData?.isActive === false) {
          throw new HttpsError(
            "failed-precondition",
            "Pickup slot is not active"
          );
        }

        // Check if slot date is in the future
        const slotDate = slotData?.date?.toDate();
        if (slotDate && slotDate < new Date()) {
          throw new HttpsError(
            "failed-precondition",
            ErrorMessages.SLOT_EXPIRED
          );
        }

        // Get capacity info
        const capacityWeightKg = slotData?.capacityWeightKg || 0;
        const usedWeightKg = slotData?.usedWeightKg || 0;
        const availableWeightKg = capacityWeightKg - usedWeightKg;

        console.log(
          `Slot capacity - Total: ${capacityWeightKg}kg, Used: ${usedWeightKg}kg, Available: ${availableWeightKg}kg`
        );

        // Check if enough capacity
        if (availableWeightKg < estWeightKg) {
          console.warn(
            `Insufficient capacity - Required: ${estWeightKg}kg, Available: ${availableWeightKg}kg`
          );

          return {
            ok: false,
            message: ErrorMessages.SLOT_FULL,
            availableWeightKg,
            slotDetails: {
              date: slotDate,
              startTime: slotData?.startTime || "",
              endTime: slotData?.endTime || "",
              capacityWeightKg,
              usedWeightKg,
            },
          };
        }

        // Reserve capacity
        const newUsedWeight = usedWeightKg + estWeightKg;

        transaction.update(slotRef, {
          usedWeightKg: newUsedWeight,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log(
          `Slot reserved - New used weight: ${newUsedWeight}kg / ${capacityWeightKg}kg`
        );

        // Log reservation (optional)
        if (requestId) {
          const logRef = collections
            .pickupSlots()
            .doc(slotId)
            .collection("reservations")
            .doc();
          transaction.set(logRef, {
            uid,
            requestId,
            weightKg: estWeightKg,
            reservedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }

        // Success response
        return {
          ok: true,
          message: "Slot reserved successfully",
          availableWeightKg: availableWeightKg - estWeightKg,
          slotDetails: {
            date: slotDate,
            startTime: slotData?.startTime || "",
            endTime: slotData?.endTime || "",
            capacityWeightKg,
            usedWeightKg: newUsedWeight,
          },
        };
      });
    },
    {
      ttl: 3600, // 1 hour TTL
      metadata: { slotId, estWeightKg, requestId },
    }
  );
});

/**
 * Release Slot Function
 * Release previously reserved capacity (e.g., when pickup is canceled)
 *
 * Input:
 * - slotId: string
 * - weightKg: number
 *
 * Output:
 * - ok: boolean
 * - message: string
 */

interface ReleaseSlotRequest {
  slotId: string;
  weightKg: number;
  requestId?: string;
}

interface ReleaseSlotResponse {
  ok: boolean;
  message: string;
  newAvailableWeightKg?: number;
}

export const releaseSlot = onCall<
  ReleaseSlotRequest,
  Promise<ReleaseSlotResponse>
>(async (request) => {
  // ============================================
  // AUTHENTICATION
  // ============================================
  const uid = requireAuth(request);
  await getAuthContext(request);

  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { slotId, weightKg, requestId } = request.data;

  if (!slotId || typeof slotId !== "string") {
    throw new HttpsError("invalid-argument", "Invalid slot ID");
  }

  if (!isPositiveNumber(weightKg)) {
    throw new HttpsError("invalid-argument", "Weight must be positive");
  }

  console.log(
    `Release slot request - User: ${uid}, Slot: ${slotId}, Weight: ${weightKg}kg`
  );

  // ============================================
  // ATOMIC TRANSACTION
  // ============================================
  return runTransaction(async (transaction) => {
    // Get slot document
    const slotRef = collections.pickupSlots().doc(slotId);
    const slotDoc = await transaction.get(slotRef);

    if (!slotDoc.exists) {
      throw new HttpsError("not-found", "Slot not found");
    }

    const slotData = slotDoc.data();
    const capacityWeightKg = slotData?.capacityWeightKg || 0;
    const usedWeightKg = slotData?.usedWeightKg || 0;

    // Calculate new used weight (can't go below 0)
    const newUsedWeight = Math.max(0, usedWeightKg - weightKg);

    transaction.update(slotRef, {
      usedWeightKg: newUsedWeight,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(
      `Slot released - Previous: ${usedWeightKg}kg, Released: ${weightKg}kg, New: ${newUsedWeight}kg`
    );

    // Log release (optional)
    if (requestId) {
      const logRef = collections
        .pickupSlots()
        .doc(slotId)
        .collection("releases")
        .doc();
      transaction.set(logRef, {
        uid,
        requestId,
        weightKg,
        releasedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    return {
      ok: true,
      message: "Slot capacity released successfully",
      newAvailableWeightKg: capacityWeightKg - newUsedWeight,
    };
  });
});

/**
 * Check Slot Availability Function
 * Check if slot has enough capacity without reserving
 *
 * Input:
 * - slotId: string
 * - requiredWeightKg: number
 *
 * Output:
 * - available: boolean
 * - availableWeightKg: number
 * - slotDetails: object
 */

interface CheckSlotRequest {
  slotId: string;
  requiredWeightKg: number;
}

interface CheckSlotResponse {
  available: boolean;
  availableWeightKg: number;
  slotDetails: {
    date: Date;
    startTime: string;
    endTime: string;
    capacityWeightKg: number;
    usedWeightKg: number;
    zoneId: string;
    isActive: boolean;
  };
}

export const checkSlotAvailability = onCall<
  CheckSlotRequest,
  Promise<CheckSlotResponse>
>(async (request) => {
  // No auth required for checking availability

  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { slotId, requiredWeightKg } = request.data;

  if (!slotId || typeof slotId !== "string") {
    throw new HttpsError("invalid-argument", "Invalid slot ID");
  }

  if (!isPositiveNumber(requiredWeightKg)) {
    throw new HttpsError(
      "invalid-argument",
      "Required weight must be positive"
    );
  }

  // ============================================
  // GET SLOT DATA
  // ============================================
  const slotDoc = await collections.pickupSlots().doc(slotId).get();

  if (!slotDoc.exists) {
    throw new HttpsError("not-found", "Slot not found");
  }

  const slotData = slotDoc.data();

  const capacityWeightKg = slotData?.capacityWeightKg || 0;
  const usedWeightKg = slotData?.usedWeightKg || 0;
  const availableWeightKg = capacityWeightKg - usedWeightKg;
  const isActive = slotData?.isActive ?? true;

  const slotDate = slotData?.date?.toDate();
  const isFuture = slotDate && slotDate > new Date();

  return {
    available: availableWeightKg >= requiredWeightKg && isActive && isFuture,
    availableWeightKg,
    slotDetails: {
      date: slotDate,
      startTime: slotData?.startTime || "",
      endTime: slotData?.endTime || "",
      capacityWeightKg,
      usedWeightKg,
      zoneId: slotData?.zoneId || "",
      isActive,
    },
  };
});

/**
 * Get Available Slots Function
 * Get all available slots for a date and zone
 *
 * Input:
 * - date: string (ISO format)
 * - zoneId: string
 * - minWeightKg?: number (optional, filter by minimum capacity)
 *
 * Output:
 * - slots: array of slot objects
 */

interface GetAvailableSlotsRequest {
  date: string;
  zoneId: string;
  minWeightKg?: number;
}

interface SlotInfo {
  id: string;
  date: Date;
  startTime: string;
  endTime: string;
  zoneId: string;
  capacityWeightKg: number;
  usedWeightKg: number;
  availableWeightKg: number;
  isActive: boolean;
}

interface GetAvailableSlotsResponse {
  slots: SlotInfo[];
  totalSlots: number;
}

export const getAvailableSlots = onCall<
  GetAvailableSlotsRequest,
  Promise<GetAvailableSlotsResponse>
>(async (request) => {
  // ============================================
  // INPUT VALIDATION
  // ============================================
  const { date, zoneId, minWeightKg = 0 } = request.data;

  if (!date || !zoneId) {
    throw new HttpsError("invalid-argument", "Date and zone ID are required");
  }

  // Parse date
  const targetDate = new Date(date);
  if (isNaN(targetDate.getTime())) {
    throw new HttpsError("invalid-argument", "Invalid date format");
  }

  // Get start and end of day
  const startOfDay = new Date(targetDate);
  startOfDay.setHours(0, 0, 0, 0);

  const endOfDay = new Date(targetDate);
  endOfDay.setHours(23, 59, 59, 999);

  console.log(`Getting available slots - Date: ${date}, Zone: ${zoneId}`);

  // ============================================
  // QUERY SLOTS
  // ============================================
  const slotsSnapshot = await collections
    .pickupSlots()
    .where("zoneId", "==", zoneId)
    .where("date", ">=", admin.firestore.Timestamp.fromDate(startOfDay))
    .where("date", "<=", admin.firestore.Timestamp.fromDate(endOfDay))
    .where("isActive", "==", true)
    .orderBy("date")
    .orderBy("startTime")
    .get();

  const slots: SlotInfo[] = [];

  slotsSnapshot.forEach((doc) => {
    const data = doc.data();
    const capacityWeightKg = data.capacityWeightKg || 0;
    const usedWeightKg = data.usedWeightKg || 0;
    const availableWeightKg = capacityWeightKg - usedWeightKg;

    // Filter by minimum capacity if specified
    if (availableWeightKg >= minWeightKg) {
      slots.push({
        id: doc.id,
        date: data.date?.toDate(),
        startTime: data.startTime || "",
        endTime: data.endTime || "",
        zoneId: data.zoneId || "",
        capacityWeightKg,
        usedWeightKg,
        availableWeightKg,
        isActive: data.isActive ?? true,
      });
    }
  });

  console.log(`Found ${slots.length} available slots`);

  return {
    slots,
    totalSlots: slots.length,
  };
});
