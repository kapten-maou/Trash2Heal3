import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getAuthContext, requireAuth } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import { withIdempotency, generateRedeemCouponKey } from "../utils/idempotency";
import { writeLedger } from "./ledger";
import * as admin from "firebase-admin";

interface RedeemToCouponRequest {
  qtyCoupons: number;
  idempotencyKey?: string;
}

interface RedeemToCouponResponse {
  success: boolean;
  coupons: Array<{
    id: string;
    code: string;
    amount: number;
    expiresAt: string;
  }>;
  pointsDeducted: number;
  newBalance: number;
}

/**
 * Generate unique coupon code
 * Format: T2H-XXXXXX-timestamp
 */
function generateCouponCode(): string {
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // No confusing chars
  let code = "T2H-";

  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }

  const timestamp = Date.now().toString(36).toUpperCase();
  code += `-${timestamp}`;

  return code;
}

/**
 * Calculate expiry date (90 days from now)
 */
function calculateExpiryDate(): Date {
  const expiry = new Date();
  expiry.setDate(expiry.getDate() + 90);
  return expiry;
}

/**
 * Redeem points to coupons
 * Each coupon costs 1000 points and worth 10,000 IDR
 */
export const redeemToCoupon = onCall<
  RedeemToCouponRequest,
  Promise<RedeemToCouponResponse>
>(async (request) => {
  const uid = requireAuth(request);
  const { qtyCoupons, idempotencyKey } = request.data;

  // Validation
  if (!qtyCoupons || qtyCoupons < 1 || qtyCoupons > 100) {
    throw new HttpsError(
      "invalid-argument",
      "Quantity must be between 1 and 100 coupons"
    );
  }

  const pointsRequired = qtyCoupons * 1000;
  const couponAmount = 10000; // 10k IDR per coupon

  // Idempotency check
  const idemKey = idempotencyKey || generateRedeemCouponKey(uid, qtyCoupons);
  const existingResult = await withIdempotency<RedeemToCouponResponse>(
    idemKey,
    async () => {
      // Run transaction
      const result = await runTransaction(async (transaction) => {
        // Get user document
        const userRef = collections.users.doc(uid);
        const userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw new HttpsError("not-found", "User not found");
        }

        const userData = userDoc.data()!;
        const currentBalance = userData.points?.balance || 0;

        // Check sufficient points
        if (currentBalance < pointsRequired) {
          throw new HttpsError(
            "failed-precondition",
            `Insufficient points. Required: ${pointsRequired}, Available: ${currentBalance}`
          );
        }

        // Generate coupons
        const coupons: Array<{
          id: string;
          code: string;
          amount: number;
          expiresAt: string;
        }> = [];
        const expiryDate = calculateExpiryDate();
        const now = admin.firestore.Timestamp.now();

        for (let i = 0; i < qtyCoupons; i++) {
          const couponCode = generateCouponCode();
          const couponRef = collections.coupons.doc();

          const couponData = {
            id: couponRef.id,
            userId: uid,
            code: couponCode,
            amount: couponAmount,
            status: "active" as const,
            source: "redeem" as const,
            createdAt: now,
            expiresAt: admin.firestore.Timestamp.fromDate(expiryDate),
            usedAt: null,
            eventId: null,
          };

          transaction.set(couponRef, couponData);

          coupons.push({
            id: couponRef.id,
            code: couponCode,
            amount: couponAmount,
            expiresAt: expiryDate.toISOString(),
          });
        }

        // Deduct points from user
        const newBalance = currentBalance - pointsRequired;
        const newCouponBalance =
          (userData.points?.couponBalance || 0) + qtyCoupons;

        transaction.update(userRef, {
          "points.balance": newBalance,
          "points.couponBalance": newCouponBalance,
          "points.totalRedeemed":
            (userData.points?.totalRedeemed || 0) + pointsRequired,
          "points.lastRedeemAt": now,
        });

        // Write to point ledger
        const ledgerRef = collections.pointLedger.doc();
        transaction.set(ledgerRef, {
          id: ledgerRef.id,
          userId: uid,
          delta: -pointsRequired,
          reason: "redeem_coupon",
          description: `Redeemed ${qtyCoupons} coupon(s) worth ${
            qtyCoupons * couponAmount
          } IDR`,
          refId: coupons[0].id, // Reference first coupon
          refType: "coupon",
          metadata: {
            qtyCoupons,
            couponAmount,
            couponIds: coupons.map((c) => c.id),
          },
          createdAt: now,
          balanceAfter: newBalance,
        });

        return {
          success: true,
          coupons,
          pointsDeducted: pointsRequired,
          newBalance,
        };
      });

      // Send notification (outside transaction)
      try {
        await collections.notifications.add({
          userId: uid,
          title: "Penukaran Poin Berhasil! 🎉",
          body: `${qtyCoupons} kupon senilai ${
            qtyCoupons * couponAmount
          } IDR telah masuk ke akun Anda`,
          type: "redeem_success",
          read: false,
          data: {
            type: "redeem_coupon",
            qtyCoupons,
            pointsDeducted: pointsRequired,
          },
          createdAt: admin.firestore.Timestamp.now(),
        });
      } catch (error) {
        console.error("Failed to send notification:", error);
        // Don't fail the whole operation if notification fails
      }

      return result;
    }
  );

  return existingResult;
});
