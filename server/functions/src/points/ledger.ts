/**
 * TRASH2HEAL Point Ledger System
 *
 * This module provides helper functions for managing point transactions
 * and maintaining accurate point balances for users.
 *
 * Features:
 * - Write ledger entries
 * - Query transactions
 * - Calculate balances
 * - Analytics and statistics
 */

import { collections } from "../utils/firestore";
import * as admin from "firebase-admin";

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

/**
 * Point transaction record
 */
export interface Transaction {
  id: string;
  userId: string;
  delta: number; // Change in points (+/-)
  reason: string; // Transaction reason
  description: string; // Human-readable description
  refId?: string | null; // Reference ID (pickup, coupon, etc)
  refType?: string | null; // Reference type
  metadata?: any; // Additional data
  createdAt: admin.firestore.Timestamp;
  balanceAfter: number; // Balance after transaction
}

/**
 * Parameters for writing ledger entry
 */
export interface WriteLedgerParams {
  uid: string;
  delta: number;
  reason: string;
  description: string;
  refId?: string;
  refType?: string;
  metadata?: any;
}

// ============================================================================
// WRITE OPERATIONS
// ============================================================================

/**
 * Write a single entry to point ledger
 *
 * This function:
 * 1. Validates sufficient points (if delta is negative)
 * 2. Creates ledger entry
 * 3. Updates user balance
 *
 * Use this for operations OUTSIDE transactions
 * For operations inside transactions, write directly to collections
 *
 * @param params - Ledger entry parameters
 * @returns Created ledger entry ID
 * @throws Error if user not found or insufficient points
 *
 * @example
 * ```typescript
 * const ledgerId = await writeLedger({
 *   uid: 'user_123',
 *   delta: -1000,
 *   reason: 'redeem_coupon',
 *   description: 'Redeemed 1 coupon worth 10,000 IDR',
 *   refId: 'coupon_xyz',
 *   refType: 'coupon',
 * });
 * ```
 */
export async function writeLedger(params: WriteLedgerParams): Promise<string> {
  const { uid, delta, reason, description, refId, refType, metadata } = params;

  // Get current user data
  const userRef = collections.users.doc(uid);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    throw new Error(`User not found: ${uid}`);
  }

  const userData = userDoc.data()!;
  const currentBalance = userData.points?.balance || 0;
  const newBalance = currentBalance + delta;

  // Prevent negative balance
  if (newBalance < 0) {
    throw new Error(
      `Insufficient points. Current: ${currentBalance}, Required: ${Math.abs(
        delta
      )}, Deficit: ${Math.abs(newBalance)}`
    );
  }

  const now = admin.firestore.Timestamp.now();

  // Create ledger entry
  const ledgerRef = collections.pointLedger.doc();
  const ledgerData: Transaction = {
    id: ledgerRef.id,
    userId: uid,
    delta,
    reason,
    description,
    refId: refId || null,
    refType: refType || null,
    metadata: metadata || null,
    createdAt: now,
    balanceAfter: newBalance,
  };

  await ledgerRef.set(ledgerData);

  // Update user balance
  await userRef.update({
    "points.balance": newBalance,
    "points.lastUpdatedAt": now,
  });

  console.log(
    `✅ Ledger written: ${uid} | ${
      delta > 0 ? "+" : ""
    }${delta} | Balance: ${newBalance} | Reason: ${reason}`
  );

  return ledgerRef.id;
}

// ============================================================================
// BALANCE OPERATIONS
// ============================================================================

/**
 * Get user's current points balance
 *
 * @param uid - User ID
 * @returns Current balance in points
 * @throws Error if user not found
 *
 * @example
 * ```typescript
 * const balance = await getUserBalance('user_123');
 * console.log(`User has ${balance} points`);
 * ```
 */
export async function getUserBalance(uid: string): Promise<number> {
  const userRef = collections.users.doc(uid);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    throw new Error(`User not found: ${uid}`);
  }

  const userData = userDoc.data()!;
  return userData.points?.balance || 0;
}

/**
 * Validate if user has sufficient points
 *
 * @param uid - User ID
 * @param requiredPoints - Points required
 * @returns True if user has enough points, false otherwise
 *
 * @example
 * ```typescript
 * const canRedeem = await validateSufficientPoints('user_123', 5000);
 * if (!canRedeem) {
 *   throw new Error('Insufficient points');
 * }
 * ```
 */
export async function validateSufficientPoints(
  uid: string,
  requiredPoints: number
): Promise<boolean> {
  try {
    const currentBalance = await getUserBalance(uid);
    return currentBalance >= requiredPoints;
  } catch (error) {
    return false;
  }
}

// ============================================================================
// QUERY OPERATIONS
// ============================================================================

/**
 * Get recent transactions for a user
 *
 * @param uid - User ID
 * @param limit - Number of transactions to fetch (default: 10, max: 100)
 * @returns Array of transactions, newest first
 *
 * @example
 * ```typescript
 * const recent = await getRecentTransactions('user_123', 20);
 * recent.forEach(tx => {
 *   console.log(`${tx.description}: ${tx.delta} points`);
 * });
 * ```
 */
export async function getRecentTransactions(
  uid: string,
  limit: number = 10
): Promise<Transaction[]> {
  // Enforce max limit
  const safeLimit = Math.min(limit, 100);

  const snapshot = await collections.pointLedger
    .where("userId", "==", uid)
    .orderBy("createdAt", "desc")
    .limit(safeLimit)
    .get();

  const transactions: Transaction[] = [];

  snapshot.forEach((doc) => {
    const data = doc.data();
    transactions.push({
      id: doc.id,
      userId: data.userId,
      delta: data.delta,
      reason: data.reason,
      description: data.description,
      refId: data.refId || null,
      refType: data.refType || null,
      metadata: data.metadata || null,
      createdAt: data.createdAt,
      balanceAfter: data.balanceAfter,
    });
  });

  return transactions;
}

/**
 * Get transactions by date range
 *
 * @param uid - User ID
 * @param startDate - Start date (inclusive)
 * @param endDate - End date (inclusive)
 * @returns Array of transactions in date range
 *
 * @example
 * ```typescript
 * const startDate = new Date('2024-01-01');
 * const endDate = new Date('2024-01-31');
 * const januaryTxs = await getTransactionsByDateRange('user_123', startDate, endDate);
 * console.log(`January transactions: ${januaryTxs.length}`);
 * ```
 */
export async function getTransactionsByDateRange(
  uid: string,
  startDate: Date,
  endDate: Date
): Promise<Transaction[]> {
  const startTimestamp = admin.firestore.Timestamp.fromDate(startDate);
  const endTimestamp = admin.firestore.Timestamp.fromDate(endDate);

  const snapshot = await collections.pointLedger
    .where("userId", "==", uid)
    .where("createdAt", ">=", startTimestamp)
    .where("createdAt", "<=", endTimestamp)
    .orderBy("createdAt", "desc")
    .get();

  const transactions: Transaction[] = [];

  snapshot.forEach((doc) => {
    const data = doc.data();
    transactions.push({
      id: doc.id,
      userId: data.userId,
      delta: data.delta,
      reason: data.reason,
      description: data.description,
      refId: data.refId || null,
      refType: data.refType || null,
      metadata: data.metadata || null,
      createdAt: data.createdAt,
      balanceAfter: data.balanceAfter,
    });
  });

  return transactions;
}

/**
 * Get transactions by reason type
 *
 * @param uid - User ID
 * @param reason - Reason filter
 * @param limit - Number of transactions to fetch
 * @returns Array of filtered transactions
 *
 * @example
 * ```typescript
 * // Get all pickup earnings
 * const pickups = await getTransactionsByReason('user_123', 'pickup_completed', 50);
 *
 * // Get all coupon redemptions
 * const coupons = await getTransactionsByReason('user_123', 'redeem_coupon', 50);
 * ```
 */
export async function getTransactionsByReason(
  uid: string,
  reason: string,
  limit: number = 10
): Promise<Transaction[]> {
  const safeLimit = Math.min(limit, 100);

  const snapshot = await collections.pointLedger
    .where("userId", "==", uid)
    .where("reason", "==", reason)
    .orderBy("createdAt", "desc")
    .limit(safeLimit)
    .get();

  const transactions: Transaction[] = [];

  snapshot.forEach((doc) => {
    const data = doc.data();
    transactions.push({
      id: doc.id,
      userId: data.userId,
      delta: data.delta,
      reason: data.reason,
      description: data.description,
      refId: data.refId || null,
      refType: data.refType || null,
      metadata: data.metadata || null,
      createdAt: data.createdAt,
      balanceAfter: data.balanceAfter,
    });
  });

  return transactions;
}

// ============================================================================
// ANALYTICS OPERATIONS
// ============================================================================

/**
 * Calculate total points earned in a date range
 *
 * @param uid - User ID
 * @param startDate - Start date
 * @param endDate - End date
 * @returns Total points earned (sum of positive deltas)
 *
 * @example
 * ```typescript
 * const startDate = new Date('2024-01-01');
 * const endDate = new Date('2024-01-31');
 * const earned = await getTotalPointsEarned('user_123', startDate, endDate);
 * console.log(`Earned ${earned} points in January`);
 * ```
 */
export async function getTotalPointsEarned(
  uid: string,
  startDate: Date,
  endDate: Date
): Promise<number> {
  const transactions = await getTransactionsByDateRange(
    uid,
    startDate,
    endDate
  );

  return transactions
    .filter((t) => t.delta > 0)
    .reduce((sum, t) => sum + t.delta, 0);
}

/**
 * Calculate total points redeemed in a date range
 *
 * @param uid - User ID
 * @param startDate - Start date
 * @param endDate - End date
 * @returns Total points redeemed (absolute value of negative deltas)
 *
 * @example
 * ```typescript
 * const startDate = new Date('2024-01-01');
 * const endDate = new Date('2024-01-31');
 * const redeemed = await getTotalPointsRedeemed('user_123', startDate, endDate);
 * console.log(`Redeemed ${redeemed} points in January`);
 * ```
 */
export async function getTotalPointsRedeemed(
  uid: string,
  startDate: Date,
  endDate: Date
): Promise<number> {
  const transactions = await getTransactionsByDateRange(
    uid,
    startDate,
    endDate
  );

  return transactions
    .filter((t) => t.delta < 0)
    .reduce((sum, t) => sum + Math.abs(t.delta), 0);
}

/**
 * Get comprehensive points statistics for a user
 *
 * @param uid - User ID
 * @returns Statistics object with balance, totals, counts, and last transaction
 *
 * @example
 * ```typescript
 * const stats = await getPointsStatistics('user_123');
 * console.log(`Current: ${stats.currentBalance}`);
 * console.log(`Earned: ${stats.totalEarned}`);
 * console.log(`Redeemed: ${stats.totalRedeemed}`);
 * console.log(`Transactions: ${stats.transactionCount}`);
 * ```
 */
export async function getPointsStatistics(uid: string): Promise<{
  currentBalance: number;
  totalEarned: number;
  totalRedeemed: number;
  transactionCount: number;
  lastTransaction?: Transaction;
}> {
  const userRef = collections.users.doc(uid);
  const userDoc = await userRef.get();

  if (!userDoc.exists) {
    throw new Error(`User not found: ${uid}`);
  }

  const userData = userDoc.data()!;

  // Get last transaction
  const recentTransactions = await getRecentTransactions(uid, 1);

  // Get all transactions for totals
  const allTransactionsSnapshot = await collections.pointLedger
    .where("userId", "==", uid)
    .get();

  let totalEarned = 0;
  let totalRedeemed = 0;

  allTransactionsSnapshot.forEach((doc) => {
    const delta = doc.data().delta;
    if (delta > 0) {
      totalEarned += delta;
    } else {
      totalRedeemed += Math.abs(delta);
    }
  });

  return {
    currentBalance: userData.points?.balance || 0,
    totalEarned,
    totalRedeemed,
    transactionCount: allTransactionsSnapshot.size,
    lastTransaction: recentTransactions[0] || undefined,
  };
}

// ============================================================================
// BATCH OPERATIONS
// ============================================================================

/**
 * Batch write multiple ledger entries
 *
 * WARNING: This does NOT update user balances automatically
 * Use this only for bulk operations where balances are managed separately
 *
 * @param entries - Array of ledger entries to write
 * @returns Array of created ledger IDs
 *
 * @example
 * ```typescript
 * const entries = [
 *   { uid: 'user_1', delta: 100, reason: 'bonus', description: 'Welcome bonus' },
 *   { uid: 'user_2', delta: 100, reason: 'bonus', description: 'Welcome bonus' },
 * ];
 * const ids = await batchWriteLedger(entries);
 * console.log(`Created ${ids.length} ledger entries`);
 * ```
 */
export async function batchWriteLedger(
  entries: WriteLedgerParams[]
): Promise<string[]> {
  const batch = admin.firestore().batch();
  const ledgerIds: string[] = [];
  const now = admin.firestore.Timestamp.now();

  for (const entry of entries) {
    const ledgerRef = collections.pointLedger.doc();

    // Get current balance for this entry
    const currentBalance = await getUserBalance(entry.uid);
    const newBalance = currentBalance + entry.delta;

    const ledgerData: Transaction = {
      id: ledgerRef.id,
      userId: entry.uid,
      delta: entry.delta,
      reason: entry.reason,
      description: entry.description,
      refId: entry.refId || null,
      refType: entry.refType || null,
      metadata: entry.metadata || null,
      createdAt: now,
      balanceAfter: newBalance,
    };

    batch.set(ledgerRef, ledgerData);
    ledgerIds.push(ledgerRef.id);
  }

  await batch.commit();

  console.log(`✅ Batch ledger written: ${ledgerIds.length} entries`);

  return ledgerIds;
}

// ============================================================================
// COMMON REASON TYPES
// ============================================================================

/**
 * Standard reason types for point transactions
 * Use these for consistency across the application
 */
export const LEDGER_REASONS = {
  // Earning points
  PICKUP_COMPLETED: "pickup_completed",
  MEMBERSHIP_BONUS: "membership_bonus",
  REFERRAL_BONUS: "referral_bonus",
  MANUAL_ADJUSTMENT: "manual_adjustment",

  // Redeeming points
  REDEEM_COUPON: "redeem_coupon",
  REDEEM_BALANCE: "redeem_balance",

  // Corrections
  CORRECTION_POSITIVE: "correction_positive",
  CORRECTION_NEGATIVE: "correction_negative",
} as const;
