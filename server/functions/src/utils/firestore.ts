import * as admin from "firebase-admin";

// Initialize Firestore
const db = admin.firestore();

/**
 * Firestore Helper Utilities
 * Provides convenient access to collections and transactions
 */

// ============================================
// COLLECTION REFERENCES
// ============================================

export const collections = {
  users: () => db.collection("users"),
  addresses: () => db.collection("addresses"),
  paymentMethods: () => db.collection("payment_methods"),
  pickupRates: () => db.collection("pickup_rates"),
  pickupSlots: () => db.collection("pickup_slots"),
  pickupRequests: () => db.collection("pickup_requests"),
  pickupTasks: () => db.collection("pickup_tasks"),
  pointLedger: () => db.collection("point_ledger"),
  coupons: () => db.collection("coupons"),
  redeemRequests: () => db.collection("redeem_requests"),
  events: () => db.collection("events"),
  eventItems: () => db.collection("event_items"),
  voucherScans: () => db.collection("voucher_scans"),
  notifications: () => db.collection("notifications"),
  chatThreads: () => db.collection("chat_threads"),
  chatMessages: (threadId: string) =>
    db.collection("chat_threads").doc(threadId).collection("messages"),
  membershipPlans: () => db.collection("membership_plans"),
  idempotencyKeys: () => db.collection("idempotency_keys"),
};

// ============================================
// DOCUMENT HELPERS
// ============================================

/**
 * Get document by ID
 */
export async function getDoc<T>(
  collectionPath: string,
  docId: string
): Promise<T | null> {
  const doc = await db.collection(collectionPath).doc(docId).get();
  if (!doc.exists) return null;
  return { id: doc.id, ...doc.data() } as T;
}

/**
 * Get multiple documents by IDs
 */
export async function getDocs<T>(
  collectionPath: string,
  docIds: string[]
): Promise<T[]> {
  const promises = docIds.map((id) => getDoc<T>(collectionPath, id));
  const results = await Promise.all(promises);
  return results.filter((doc) => doc !== null) as T[];
}

/**
 * Create document with auto-generated ID
 */
export async function createDoc<T>(
  collectionPath: string,
  data: T
): Promise<string> {
  const docRef = await db.collection(collectionPath).add({
    ...data,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

/**
 * Create document with specific ID
 */
export async function setDoc<T>(
  collectionPath: string,
  docId: string,
  data: T
): Promise<void> {
  await db
    .collection(collectionPath)
    .doc(docId)
    .set({
      ...data,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}

/**
 * Update document
 */
export async function updateDoc(
  collectionPath: string,
  docId: string,
  data: Partial<any>
): Promise<void> {
  await db
    .collection(collectionPath)
    .doc(docId)
    .update({
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}

/**
 * Delete document
 */
export async function deleteDoc(
  collectionPath: string,
  docId: string
): Promise<void> {
  await db.collection(collectionPath).doc(docId).delete();
}

// ============================================
// QUERY HELPERS
// ============================================

/**
 * Query documents with filters
 */
export async function queryDocs<T>(
  collectionPath: string,
  filters: Array<{
    field: string;
    operator: FirebaseFirestore.WhereFilterOp;
    value: any;
  }>,
  orderBy?: { field: string; direction?: "asc" | "desc" },
  limit?: number
): Promise<T[]> {
  let query: FirebaseFirestore.Query = db.collection(collectionPath);

  // Apply filters
  filters.forEach((filter) => {
    query = query.where(filter.field, filter.operator, filter.value);
  });

  // Apply ordering
  if (orderBy) {
    query = query.orderBy(orderBy.field, orderBy.direction || "asc");
  }

  // Apply limit
  if (limit) {
    query = query.limit(limit);
  }

  const snapshot = await query.get();
  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as T));
}

/**
 * Count documents matching filters
 */
export async function countDocs(
  collectionPath: string,
  filters: Array<{
    field: string;
    operator: FirebaseFirestore.WhereFilterOp;
    value: any;
  }>
): Promise<number> {
  let query: FirebaseFirestore.Query = db.collection(collectionPath);

  filters.forEach((filter) => {
    query = query.where(filter.field, filter.operator, filter.value);
  });

  const snapshot = await query.count().get();
  return snapshot.data().count;
}

// ============================================
// TRANSACTION HELPERS
// ============================================

/**
 * Run atomic transaction
 */
export async function runTransaction<T>(
  callback: (transaction: FirebaseFirestore.Transaction) => Promise<T>
): Promise<T> {
  return db.runTransaction(callback);
}

/**
 * Increment field atomically
 */
export async function incrementField(
  collectionPath: string,
  docId: string,
  field: string,
  value: number
): Promise<void> {
  const docRef = db.collection(collectionPath).doc(docId);
  await docRef.update({
    [field]: admin.firestore.FieldValue.increment(value),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

/**
 * Decrement field atomically
 */
export async function decrementField(
  collectionPath: string,
  docId: string,
  field: string,
  value: number
): Promise<void> {
  await incrementField(collectionPath, docId, field, -value);
}

/**
 * Array union (add to array without duplicates)
 */
export async function arrayUnion(
  collectionPath: string,
  docId: string,
  field: string,
  values: any[]
): Promise<void> {
  const docRef = db.collection(collectionPath).doc(docId);
  await docRef.update({
    [field]: admin.firestore.FieldValue.arrayUnion(...values),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

/**
 * Array remove
 */
export async function arrayRemove(
  collectionPath: string,
  docId: string,
  field: string,
  values: any[]
): Promise<void> {
  const docRef = db.collection(collectionPath).doc(docId);
  await docRef.update({
    [field]: admin.firestore.FieldValue.arrayRemove(...values),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
}

// ============================================
// BATCH OPERATIONS
// ============================================

/**
 * Batch write helper
 */
export class BatchWriter {
  private batch: FirebaseFirestore.WriteBatch;
  private operationCount = 0;
  private readonly MAX_BATCH_SIZE = 500;

  constructor() {
    this.batch = db.batch();
  }

  /**
   * Set document in batch
   */
  set<T>(collectionPath: string, docId: string, data: T): void {
    this.checkBatchSize();
    const docRef = db.collection(collectionPath).doc(docId);
    this.batch.set(docRef, {
      ...data,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    this.operationCount++;
  }

  /**
   * Update document in batch
   */
  update(collectionPath: string, docId: string, data: Partial<any>): void {
    this.checkBatchSize();
    const docRef = db.collection(collectionPath).doc(docId);
    this.batch.update(docRef, {
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    this.operationCount++;
  }

  /**
   * Delete document in batch
   */
  delete(collectionPath: string, docId: string): void {
    this.checkBatchSize();
    const docRef = db.collection(collectionPath).doc(docId);
    this.batch.delete(docRef);
    this.operationCount++;
  }

  /**
   * Commit batch
   */
  async commit(): Promise<void> {
    if (this.operationCount > 0) {
      await this.batch.commit();
    }
  }

  /**
   * Check if batch is full and auto-commit if needed
   */
  private checkBatchSize(): void {
    if (this.operationCount >= this.MAX_BATCH_SIZE) {
      throw new Error(
        `Batch size limit (${this.MAX_BATCH_SIZE}) reached. Please commit before adding more operations.`
      );
    }
  }
}

// ============================================
// TIMESTAMP HELPERS
// ============================================

/**
 * Get server timestamp
 */
export function serverTimestamp(): FirebaseFirestore.FieldValue {
  return admin.firestore.FieldValue.serverTimestamp();
}

/**
 * Convert Date to Firestore Timestamp
 */
export function toTimestamp(date: Date): admin.firestore.Timestamp {
  return admin.firestore.Timestamp.fromDate(date);
}

/**
 * Convert Firestore Timestamp to Date
 */
export function toDate(timestamp: admin.firestore.Timestamp): Date {
  return timestamp.toDate();
}

// ============================================
// PAGINATION HELPERS
// ============================================

export interface PaginationOptions {
  limit: number;
  startAfter?: FirebaseFirestore.DocumentSnapshot;
  orderBy?: { field: string; direction?: "asc" | "desc" };
}

/**
 * Paginate query
 */
export async function paginateQuery<T>(
  collectionPath: string,
  filters: Array<{
    field: string;
    operator: FirebaseFirestore.WhereFilterOp;
    value: any;
  }>,
  options: PaginationOptions
): Promise<{ data: T[]; lastDoc: FirebaseFirestore.DocumentSnapshot | null }> {
  let query: FirebaseFirestore.Query = db.collection(collectionPath);

  // Apply filters
  filters.forEach((filter) => {
    query = query.where(filter.field, filter.operator, filter.value);
  });

  // Apply ordering
  if (options.orderBy) {
    query = query.orderBy(
      options.orderBy.field,
      options.orderBy.direction || "asc"
    );
  }

  // Apply pagination
  if (options.startAfter) {
    query = query.startAfter(options.startAfter);
  }

  query = query.limit(options.limit);

  const snapshot = await query.get();

  const data = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() } as T));
  const lastDoc =
    snapshot.docs.length > 0 ? snapshot.docs[snapshot.docs.length - 1] : null;

  return { data, lastDoc };
}

// ============================================
// EXPORT DB INSTANCE
// ============================================

export { db };
export default db;
