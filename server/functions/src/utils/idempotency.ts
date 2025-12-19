import * as admin from "firebase-admin";
import { https } from "firebase-functions/v2";
import { collections } from "./firestore";

/**
 * Idempotency Utilities
 * Prevents duplicate operations for payment, redemption, and other critical actions
 */

// ============================================
// TYPES
// ============================================

export interface IdempotencyRecord {
  key: string;
  uid: string;
  operation: string;
  status: "pending" | "completed" | "failed";
  result?: any;
  error?: string;
  createdAt: admin.firestore.Timestamp;
  expiresAt: admin.firestore.Timestamp;
  metadata?: Record<string, any>;
}

// ============================================
// KEY GENERATION
// ============================================

/**
 * Generate idempotency key from user ID and operation
 */
export function generateIdempotencyKey(uid: string, operation: string): string {
  const timestamp = Date.now();
  const random = Math.random().toString(36).substring(2, 15);
  return `${uid}-${operation}-${timestamp}-${random}`;
}

/**
 * Parse idempotency key to extract components
 */
export function parseIdempotencyKey(key: string): {
  uid: string;
  operation: string;
  timestamp: number;
} | null {
  const parts = key.split("-");
  if (parts.length < 3) return null;

  return {
    uid: parts[0],
    operation: parts[1],
    timestamp: parseInt(parts[2], 10),
  };
}

// ============================================
// RECORD MANAGEMENT
// ============================================

/**
 * Create idempotency record
 */
export async function createIdempotencyRecord(
  key: string,
  uid: string,
  operation: string,
  ttlSeconds: number = 86400, // 24 hours default
  metadata?: Record<string, any>
): Promise<void> {
  const now = admin.firestore.Timestamp.now();
  const expiresAt = admin.firestore.Timestamp.fromMillis(
    now.toMillis() + ttlSeconds * 1000
  );

  const record: IdempotencyRecord = {
    key,
    uid,
    operation,
    status: "pending",
    createdAt: now,
    expiresAt,
    metadata,
  };

  await collections.idempotencyKeys().doc(key).set(record);
}

/**
 * Get idempotency record
 */
export async function getIdempotencyRecord(
  key: string
): Promise<IdempotencyRecord | null> {
  const doc = await collections.idempotencyKeys().doc(key).get();

  if (!doc.exists) {
    return null;
  }

  return doc.data() as IdempotencyRecord;
}

/**
 * Check if idempotency key exists
 */
export async function idempotencyKeyExists(key: string): Promise<boolean> {
  const record = await getIdempotencyRecord(key);
  return record !== null;
}

/**
 * Update idempotency record status
 */
export async function updateIdempotencyStatus(
  key: string,
  status: "completed" | "failed",
  result?: any,
  error?: string
): Promise<void> {
  const updateData: Partial<IdempotencyRecord> = {
    status,
  };

  if (result !== undefined) {
    updateData.result = result;
  }

  if (error !== undefined) {
    updateData.error = error;
  }

  await collections
    .idempotencyKeys()
    .doc(key)
    .update(updateData as any);
}

/**
 * Mark operation as completed
 */
export async function markCompleted(key: string, result?: any): Promise<void> {
  await updateIdempotencyStatus(key, "completed", result);
}

/**
 * Mark operation as failed
 */
export async function markFailed(key: string, error: string): Promise<void> {
  await updateIdempotencyStatus(key, "failed", undefined, error);
}

// ============================================
// OPERATION GUARDS
// ============================================

/**
 * Check if operation is duplicate (idempotent check)
 */
export async function checkDuplicate(key: string): Promise<{
  isDuplicate: boolean;
  record?: IdempotencyRecord;
}> {
  const record = await getIdempotencyRecord(key);

  if (!record) {
    return { isDuplicate: false };
  }

  // Check if expired
  if (record.expiresAt.toMillis() < Date.now()) {
    // Expired, can proceed with new operation
    return { isDuplicate: false };
  }

  return {
    isDuplicate: true,
    record,
  };
}

/**
 * Execute operation with idempotency protection
 */
export async function withIdempotency<T>(
  key: string,
  uid: string,
  operation: string,
  handler: () => Promise<T>,
  options: {
    ttl?: number;
    metadata?: Record<string, any>;
  } = {}
): Promise<T> {
  // Check for duplicate
  const { isDuplicate, record } = await checkDuplicate(key);

  if (isDuplicate) {
    if (record!.status === "completed") {
      // Return cached result
      return record!.result as T;
    } else if (record!.status === "failed") {
      // Throw previous error
      throw new https.HttpsError(
        "already-exists",
        record!.error || "Operation previously failed"
      );
    } else if (record!.status === "pending") {
      // Operation in progress
      throw new https.HttpsError(
        "already-exists",
        "Operation already in progress"
      );
    }
  }

  // Create idempotency record
  await createIdempotencyRecord(
    key,
    uid,
    operation,
    options.ttl,
    options.metadata
  );

  try {
    // Execute operation
    const result = await handler();

    // Mark as completed
    await markCompleted(key, result);

    return result;
  } catch (error) {
    // Mark as failed
    const errorMessage = error instanceof Error ? error.message : String(error);
    await markFailed(key, errorMessage);

    throw error;
  }
}

// ============================================
// CLEANUP
// ============================================

/**
 * Delete expired idempotency records
 */
export async function cleanupExpiredRecords(): Promise<number> {
  const now = admin.firestore.Timestamp.now();

  const snapshot = await collections
    .idempotencyKeys()
    .where("expiresAt", "<", now)
    .limit(500) // Process in batches
    .get();

  if (snapshot.empty) {
    return 0;
  }

  const batch = admin.firestore().batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();

  return snapshot.size;
}

/**
 * Delete all idempotency records for a user
 */
export async function deleteUserIdempotencyRecords(
  uid: string
): Promise<number> {
  const snapshot = await collections
    .idempotencyKeys()
    .where("uid", "==", uid)
    .get();

  if (snapshot.empty) {
    return 0;
  }

  const batch = admin.firestore().batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();

  return snapshot.size;
}

// ============================================
// TRANSACTION WRAPPER
// ============================================

/**
 * Execute operation with both idempotency and transaction
 */
export async function withIdempotentTransaction<T>(
  key: string,
  uid: string,
  operation: string,
  handler: (transaction: admin.firestore.Transaction) => Promise<T>,
  options: {
    ttl?: number;
    metadata?: Record<string, any>;
  } = {}
): Promise<T> {
  return withIdempotency(
    key,
    uid,
    operation,
    async () => {
      return admin.firestore().runTransaction(handler);
    },
    options
  );
}

// ============================================
// PREDEFINED OPERATIONS
// ============================================

export const IdempotentOperations = {
  REDEEM_COUPON: "redeem_coupon",
  REDEEM_BALANCE: "redeem_balance",
  RESERVE_SLOT: "reserve_slot",
  CREATE_PICKUP: "create_pickup",
  COMPLETE_PICKUP: "complete_pickup",
  CREATE_PAYMENT: "create_payment",
  PROCESS_PAYMENT: "process_payment",
  ACTIVATE_MEMBERSHIP: "activate_membership",
  CASHOUT: "cashout",
  USE_COUPON: "use_coupon",
} as const;

export type IdempotentOperation =
  (typeof IdempotentOperations)[keyof typeof IdempotentOperations];

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Generate key for redeem coupon operation
 */
export function generateRedeemCouponKey(uid: string, qty: number): string {
  return `${uid}-redeem_coupon-${Date.now()}-${qty}`;
}

/**
 * Generate key for redeem balance operation
 */
export function generateRedeemBalanceKey(uid: string, amount: number): string {
  return `${uid}-redeem_balance-${Date.now()}-${amount}`;
}

/**
 * Generate key for reserve slot operation
 */
export function generateReserveSlotKey(uid: string, slotId: string): string {
  return `${uid}-reserve_slot-${slotId}-${Date.now()}`;
}

/**
 * Generate key for payment operation
 */
export function generatePaymentKey(uid: string, planId: string): string {
  return `${uid}-payment-${planId}-${Date.now()}`;
}

/**
 * Generate key for cashout operation
 */
export function generateCashoutKey(uid: string, amount: number): string {
  return `${uid}-cashout-${Date.now()}-${amount}`;
}

/**
 * Generate key for use coupon operation
 */
export function generateUseCouponKey(couponCode: string): string {
  return `use_coupon-${couponCode}-${Date.now()}`;
}

// ============================================
// ERROR HANDLING
// ============================================

/**
 * Create duplicate operation error
 */
export function duplicateOperationError(operation: string): https.HttpsError {
  return new https.HttpsError(
    "already-exists",
    `Duplicate ${operation} operation detected`
  );
}

/**
 * Create operation in progress error
 */
export function operationInProgressError(operation: string): https.HttpsError {
  return new https.HttpsError(
    "already-exists",
    `${operation} operation already in progress`
  );
}
