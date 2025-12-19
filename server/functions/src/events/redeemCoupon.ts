/**
 * TRASH2HEAL Coupon Redemption System
 *
 * This module handles coupon usage at events.
 * Users scan their coupon barcode/QR code at event booths.
 *
 * Features:
 * - Validate coupon code
 * - Check coupon status (active/used/expired)
 * - Mark coupon as used
 * - Create voucher scan record
 * - Prevent duplicate redemption
 * - Track event item redemption
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { requireAuth } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import * as admin from "firebase-admin";

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

interface RedeemCouponRequest {
  couponCode: string; // Coupon code to redeem (T2H-XXXXXX-xxx)
  eventId: string; // Event ID where coupon is used
  eventItemId?: string; // Optional: specific item being redeemed
}

interface RedeemCouponResponse {
  success: boolean;
  message: string;
  coupon: {
    id: string;
    code: string;
    amount: number;
    usedAt: string;
  };
  scanId: string;
}

// ============================================================================
// VALIDATION HELPERS
// ============================================================================

/**
 * Validate coupon code format
 * Expected format: T2H-XXXXXX-timestamp
 *
 * @param code - Coupon code to validate
 * @returns True if valid format
 */
function isValidCouponFormat(code: string): boolean {
  // Format: T2H-XXXXXX-timestamp
  const pattern = /^T2H-[A-Z0-9]{6}-[A-Z0-9]+$/;
  return pattern.test(code);
}

/**
 * Check if coupon is expired
 *
 * @param expiresAt - Expiry timestamp
 * @returns True if expired
 */
function isCouponExpired(expiresAt: admin.firestore.Timestamp): boolean {
  const now = Date.now();
  const expiryTime = expiresAt.toMillis();
  return now > expiryTime;
}

// ============================================================================
// NOTIFICATION HELPER
// ============================================================================

/**
 * Send notification after coupon redemption
 */
async function sendRedemptionNotification(
  userId: string,
  couponCode: string,
  amount: number,
  eventName: string
): Promise<void> {
  try {
    await collections.notifications.add({
      userId,
      title: "🎫 Kupon Digunakan",
      body: `Kupon ${couponCode} senilai Rp ${amount.toLocaleString(
        "id-ID"
      )} berhasil digunakan di ${eventName}`,
      type: "coupon_used",
      read: false,
      data: {
        type: "coupon_redemption",
        couponCode,
        amount,
        eventName,
      },
      createdAt: admin.firestore.Timestamp.now(),
    });

    console.log(`✅ Notification sent: ${userId} → coupon_used`);
  } catch (error) {
    console.error("❌ Failed to send notification:", error);
  }
}

// ============================================================================
// MAIN FUNCTION
// ============================================================================

/**
 * Redeem coupon at event
 *
 * This function:
 * 1. Validates coupon code format
 * 2. Finds coupon by code
 * 3. Validates ownership (coupon belongs to user)
 * 4. Checks coupon status (must be "active")
 * 5. Checks expiry date
 * 6. Validates event exists and is active
 * 7. Atomic transaction:
 *    - Mark coupon as "used"
 *    - Set usedAt timestamp
 *    - Set eventId
 *    - Create voucher_scan record
 *    - Update user couponBalance (decrement)
 *    - Optional: update event_item stock
 * 8. Send notification
 *
 * @param request - Callable request with coupon code and event ID
 * @returns Response with success status and coupon details
 */
export const redeemCoupon = onCall<
  RedeemCouponRequest,
  Promise<RedeemCouponResponse>
>(async (request) => {
  const uid = requireAuth(request);
  const { couponCode, eventId, eventItemId } = request.data;

  console.log(
    `🎫 Coupon redemption attempt: ${couponCode} by user ${uid} at event ${eventId}`
  );

  // ========== INPUT VALIDATION ==========

  if (!couponCode || typeof couponCode !== "string") {
    throw new HttpsError("invalid-argument", "Kode kupon tidak valid");
  }

  if (!isValidCouponFormat(couponCode)) {
    throw new HttpsError(
      "invalid-argument",
      "Format kode kupon salah. Format: T2H-XXXXXX-xxx"
    );
  }

  if (!eventId || typeof eventId !== "string") {
    throw new HttpsError("invalid-argument", "Event ID tidak valid");
  }

  // ========== FIND COUPON BY CODE ==========

  const couponQuery = await collections.coupons
    .where("code", "==", couponCode)
    .limit(1)
    .get();

  if (couponQuery.empty) {
    throw new HttpsError("not-found", "Kupon tidak ditemukan");
  }

  const couponDoc = couponQuery.docs[0];
  const couponData = couponDoc.data();
  const couponId = couponDoc.id;

  console.log(`📋 Coupon found: ${couponId}`);

  // ========== VALIDATE OWNERSHIP ==========

  if (couponData.userId !== uid) {
    throw new HttpsError("permission-denied", "Kupon ini bukan milik Anda");
  }

  // ========== CHECK COUPON STATUS ==========

  if (couponData.status === "used") {
    const usedDate = couponData.usedAt?.toDate().toLocaleDateString("id-ID");
    throw new HttpsError(
      "failed-precondition",
      `Kupon sudah digunakan pada ${usedDate || "sebelumnya"}`
    );
  }

  if (couponData.status === "expired") {
    throw new HttpsError("failed-precondition", "Kupon sudah kadaluarsa");
  }

  if (couponData.status !== "active") {
    throw new HttpsError(
      "failed-precondition",
      `Kupon tidak dapat digunakan. Status: ${couponData.status}`
    );
  }

  // ========== CHECK EXPIRY DATE ==========

  if (isCouponExpired(couponData.expiresAt)) {
    throw new HttpsError(
      "failed-precondition",
      "Kupon sudah melewati masa berlaku"
    );
  }

  // ========== VALIDATE EVENT ==========

  const eventRef = collections.events.doc(eventId);
  const eventDoc = await eventRef.get();

  if (!eventDoc.exists) {
    throw new HttpsError("not-found", "Event tidak ditemukan");
  }

  const eventData = eventDoc.data()!;

  // Check if event is active
  if (eventData.status !== "active") {
    throw new HttpsError(
      "failed-precondition",
      `Event tidak aktif. Status: ${eventData.status}`
    );
  }

  // Check event date
  const now = Date.now();
  const eventStart = eventData.startDate.toMillis();
  const eventEnd = eventData.endDate.toMillis();

  if (now < eventStart) {
    throw new HttpsError("failed-precondition", "Event belum dimulai");
  }

  if (now > eventEnd) {
    throw new HttpsError("failed-precondition", "Event sudah berakhir");
  }

  console.log(`✅ Event validated: ${eventData.title}`);

  // ========== VALIDATE EVENT ITEM (if specified) ==========

  let eventItemData = null;
  if (eventItemId) {
    const eventItemRef = collections.eventItems.doc(eventItemId);
    const eventItemDoc = await eventItemRef.get();

    if (!eventItemDoc.exists) {
      throw new HttpsError("not-found", "Item event tidak ditemukan");
    }

    eventItemData = eventItemDoc.data()!;

    // Check if item belongs to this event
    if (eventItemData.eventId !== eventId) {
      throw new HttpsError(
        "invalid-argument",
        "Item tidak termasuk dalam event ini"
      );
    }

    // Check stock
    if (eventItemData.stock <= 0) {
      throw new HttpsError("failed-precondition", "Stok item habis");
    }

    console.log(`✅ Event item validated: ${eventItemData.name}`);
  }

  // ========== ATOMIC TRANSACTION ==========

  const result = await runTransaction(async (transaction) => {
    const nowTimestamp = admin.firestore.Timestamp.now();

    // ========== UPDATE COUPON STATUS ==========
    const couponRef = collections.coupons.doc(couponId);
    transaction.update(couponRef, {
      status: "used",
      usedAt: nowTimestamp,
      eventId: eventId,
      eventItemId: eventItemId || null,
    });

    console.log(`✅ Coupon marked as used`);

    // ========== CREATE VOUCHER SCAN RECORD ==========
    const scanRef = collections.voucherScans.doc();
    transaction.set(scanRef, {
      id: scanRef.id,
      couponId,
      couponCode,
      userId: uid,
      eventId,
      eventItemId: eventItemId || null,
      scannedAt: nowTimestamp,
      amount: couponData.amount,
      metadata: {
        eventName: eventData.title,
        eventItemName: eventItemData?.name || null,
      },
    });

    console.log(`✅ Voucher scan record created: ${scanRef.id}`);

    // ========== UPDATE USER COUPON BALANCE ==========
    const userRef = collections.users.doc(uid);
    const userDoc = await transaction.get(userRef);

    if (userDoc.exists) {
      const userData = userDoc.data()!;
      const currentCouponBalance = userData.points?.couponBalance || 0;
      const newCouponBalance = Math.max(0, currentCouponBalance - 1);

      transaction.update(userRef, {
        "points.couponBalance": newCouponBalance,
      });

      console.log(`✅ User coupon balance updated: ${newCouponBalance}`);
    }

    // ========== UPDATE EVENT ITEM STOCK (if applicable) ==========
    if (eventItemId && eventItemData) {
      const eventItemRef = collections.eventItems.doc(eventItemId);
      transaction.update(eventItemRef, {
        stock: eventItemData.stock - 1,
        redeemedCount: (eventItemData.redeemedCount || 0) + 1,
      });

      console.log(`✅ Event item stock updated`);
    }

    return {
      success: true,
      message: "Kupon berhasil digunakan",
      coupon: {
        id: couponId,
        code: couponCode,
        amount: couponData.amount,
        usedAt: nowTimestamp.toDate().toISOString(),
      },
      scanId: scanRef.id,
    };
  });

  // ========== SEND NOTIFICATION (outside transaction) ==========
  await sendRedemptionNotification(
    uid,
    couponCode,
    couponData.amount,
    eventData.title
  );

  console.log(`🎉 Coupon redemption complete: ${couponCode}`);

  return result;
});
