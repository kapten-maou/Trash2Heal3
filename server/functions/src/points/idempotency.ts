import { collections } from "./firestore";
import * as admin from "firebase-admin";

const IDEMPOTENCY_TTL_MS = 24 * 60 * 60 * 1000; // 24 hours

interface IdempotencyRecord {
  key: string;
  result: any;
  createdAt: admin.firestore.Timestamp;
  expiresAt: admin.firestore.Timestamp;
}

/**
 * Check if an idempotency key exists and return cached result
 * @param key Unique idempotency key
 * @returns Cached result if exists and not expired, null otherwise
 */
async function checkIdempotency<T>(key: string): Promise<T | null> {
  const doc = await collections.idempotencyKeys.doc(key).get();

  if (!doc.exists) {
    return null;
  }

  const data = doc.data() as IdempotencyRecord;
  const now = admin.firestore.Timestamp.now();

  // Check if expired
  if (data.expiresAt.toMillis() < now.toMillis()) {
    // Clean up expired key
    await collections.idempotencyKeys.doc(key).delete();
    return null;
  }

  return data.result as T;
}

/**
 * Store result with idempotency key
 * @param key Unique idempotency key
 * @param result Result to cache
 */
async function storeIdempotency(key: string, result: any): Promise<void> {
  const now = admin.firestore.Timestamp.now();
  const expiresAt = admin.firestore.Timestamp.fromMillis(
    now.toMillis() + IDEMPOTENCY_TTL_MS
  );

  const record: IdempotencyRecord = {
    key,
    result,
    createdAt: now,
    expiresAt,
  };

  await collections.idempotencyKeys.doc(key).set(record);
}

/**
 * Wrapper function to handle idempotency
 * @param key Unique idempotency key
 * @param operation Async operation to execute
 * @returns Result from operation or cached result
 */
export async function withIdempotency<T>(
  key: string,
  operation: () => Promise<T>
): Promise<T> {
  // Check if already executed
  const cached = await checkIdempotency<T>(key);
  if (cached !== null) {
    console.log(`Idempotency hit for key: ${key}`);
    return cached;
  }

  // Execute operation
  const result = await operation();

  // Store result
  await storeIdempotency(key, result);

  return result;
}

/**
 * Generate idempotency key for slot reservation
 */
export function generateReserveSlotKey(
  uid: string,
  slotId: string,
  quantity: number
): string {
  return `reserve_slot:${uid}:${slotId}:${quantity}`;
}

/**
 * Generate idempotency key for courier assignment
 */
export function generateAssignCourierKey(requestId: string): string {
  return `assign_courier:${requestId}`;
}

/**
 * Generate idempotency key for task status update
 */
export function generateUpdateTaskKey(
  taskId: string,
  newStatus: string
): string {
  return `update_task:${taskId}:${newStatus}`;
}

/**
 * Generate idempotency key for redeem to coupon
 */
export function generateRedeemCouponKey(
  uid: string,
  qtyCoupons: number
): string {
  const timestamp = Date.now();
  return `redeem_coupon:${uid}:${qtyCoupons}:${timestamp}`;
}

/**
 * Generate idempotency key for redeem to balance
 */
export function generateRedeemBalanceKey(
  uid: string,
  amount: number,
  destMethodId: string
): string {
  const timestamp = Date.now();
  return `redeem_balance:${uid}:${amount}:${destMethodId}:${timestamp}`;
}

/**
 * Generate idempotency key for payment intent
 */
export function generatePaymentIntentKey(
  uid: string,
  planId: string,
  amount: number
): string {
  const timestamp = Date.now();
  return `payment_intent:${uid}:${planId}:${amount}:${timestamp}`;
}

/**
 * Clean up expired idempotency keys (can be run periodically)
 */
export async function cleanupExpiredKeys(): Promise<number> {
  const now = admin.firestore.Timestamp.now();
  const snapshot = await collections.idempotencyKeys
    .where("expiresAt", "<", now)
    .get();

  const batch = admin.firestore().batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  return snapshot.size;
}
