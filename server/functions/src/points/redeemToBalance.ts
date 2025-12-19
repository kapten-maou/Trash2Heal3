import { onCall, HttpsError } from "firebase-functions/v2/https";
import { requireAuth } from "../utils/auth";
import { collections, runTransaction } from "../utils/firestore";
import {
  withIdempotency,
  generateRedeemBalanceKey,
} from "../utils/idempotency";
import * as admin from "firebase-admin";
import * as crypto from "crypto";

interface RedeemToBalanceRequest {
  amount: number; // IDR amount (10,000 - 10,000,000)
  destMethodId: string; // payment_method document ID
  pin: string; // 6-digit PIN
  idempotencyKey?: string;
}

interface RedeemToBalanceResponse {
  success: boolean;
  requestId: string;
  pointsDeducted: number;
  newBalance: number;
  estimatedProcessing: string;
}

/**
 * Hash PIN using SHA-256
 * In production, use bcrypt for better security
 */
function hashPin(pin: string): string {
  return crypto.createHash("sha256").update(pin).digest("hex");
}

/**
 * Verify PIN against stored hash
 */
function verifyPin(inputPin: string, storedHash: string): boolean {
  const inputHash = hashPin(inputPin);
  return inputHash === storedHash;
}

/**
 * Calculate required points for cashout
 * Formula: amount / 10 (1 point = 10 IDR)
 * Example: 50,000 IDR = 5,000 points
 */
function calculateRequiredPoints(amount: number): number {
  return amount / 10;
}

/**
 * Generate unique reference number
 * Format: RDM{timestamp}{random}
 */
function generateRefNumber(): string {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 10000)
    .toString()
    .padStart(4, "0");
  return `RDM${timestamp}${random}`;
}

/**
 * Redeem points to balance (cashout to bank/e-wallet)
 * Requires PIN verification for security
 */
export const redeemToBalance = onCall<
  RedeemToBalanceRequest,
  Promise<RedeemToBalanceResponse>
>(async (request) => {
  const uid = requireAuth(request);
  const { amount, destMethodId, pin, idempotencyKey } = request.data;

  // ========== INPUT VALIDATION ==========

  if (!amount || typeof amount !== "number") {
    throw new HttpsError("invalid-argument", "Amount is required");
  }

  if (amount < 10000) {
    throw new HttpsError(
      "invalid-argument",
      "Jumlah minimal pencairan adalah Rp 10.000"
    );
  }

  if (amount > 10000000) {
    throw new HttpsError(
      "invalid-argument",
      "Jumlah maksimal pencairan adalah Rp 10.000.000"
    );
  }

  if (amount % 10000 !== 0) {
    throw new HttpsError(
      "invalid-argument",
      "Jumlah harus kelipatan Rp 10.000"
    );
  }

  if (!destMethodId || typeof destMethodId !== "string") {
    throw new HttpsError("invalid-argument", "Payment method ID is required");
  }

  if (!pin || !/^\d{6}$/.test(pin)) {
    throw new HttpsError("invalid-argument", "PIN harus 6 digit angka");
  }

  const pointsRequired = calculateRequiredPoints(amount);

  // ========== IDEMPOTENCY CHECK ==========

  const idemKey =
    idempotencyKey || generateRedeemBalanceKey(uid, amount, destMethodId);

  const existingResult = await withIdempotency<RedeemToBalanceResponse>(
    idemKey,
    async () => {
      // ========== VERIFY USER & PIN ==========

      const userRef = collections.users.doc(uid);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw new HttpsError("not-found", "User tidak ditemukan");
      }

      const userData = userDoc.data()!;

      // Check if PIN is set
      if (!userData.pinHash) {
        throw new HttpsError(
          "failed-precondition",
          "PIN belum diatur. Silakan atur PIN di menu Profil > Keamanan"
        );
      }

      // Verify PIN
      if (!verifyPin(pin, userData.pinHash)) {
        throw new HttpsError(
          "permission-denied",
          "PIN yang Anda masukkan salah"
        );
      }

      // ========== VERIFY PAYMENT METHOD ==========

      const paymentMethodRef = collections.paymentMethods.doc(destMethodId);
      const paymentMethodDoc = await paymentMethodRef.get();

      if (!paymentMethodDoc.exists) {
        throw new HttpsError("not-found", "Metode pembayaran tidak ditemukan");
      }

      const paymentMethodData = paymentMethodDoc.data()!;

      // Verify ownership
      if (paymentMethodData.userId !== uid) {
        throw new HttpsError(
          "permission-denied",
          "Metode pembayaran ini bukan milik Anda"
        );
      }

      // ========== ATOMIC TRANSACTION ==========

      const result = await runTransaction(async (transaction) => {
        // Re-read user document in transaction
        const userDocTx = await transaction.get(userRef);
        const userDataTx = userDocTx.data()!;
        const currentBalance = userDataTx.points?.balance || 0;

        // Check sufficient points
        if (currentBalance < pointsRequired) {
          throw new HttpsError(
            "failed-precondition",
            `Poin tidak cukup. Dibutuhkan: ${pointsRequired.toLocaleString(
              "id-ID"
            )}, Tersedia: ${currentBalance.toLocaleString("id-ID")}`
          );
        }

        // Create redeem request
        const redeemRef = collections.redeemRequests.doc();
        const refNumber = generateRefNumber();
        const now = admin.firestore.Timestamp.now();

        const redeemData = {
          id: redeemRef.id,
          userId: uid,
          refNumber,
          amount,
          pointsUsed: pointsRequired,
          destMethodId,
          destMethodType: paymentMethodData.type,
          destAccountNumber: paymentMethodData.accountNumber,
          destAccountName: paymentMethodData.accountName,
          status: "pending" as const,
          createdAt: now,
          processedAt: null,
          completedAt: null,
          failedAt: null,
          failureReason: null,
          metadata: {
            userEmail: userData.email,
            userName: userData.fullName,
            userPhone: userData.phone,
          },
        };

        transaction.set(redeemRef, redeemData);

        // Deduct points from user
        const newBalance = currentBalance - pointsRequired;

        transaction.update(userRef, {
          "points.balance": newBalance,
          "points.totalRedeemed":
            (userDataTx.points?.totalRedeemed || 0) + pointsRequired,
          "points.lastRedeemAt": now,
        });

        // Write to point ledger
        const ledgerRef = collections.pointLedger.doc();
        transaction.set(ledgerRef, {
          id: ledgerRef.id,
          userId: uid,
          delta: -pointsRequired,
          reason: "redeem_balance",
          description: `Pencairan saldo Rp ${amount.toLocaleString(
            "id-ID"
          )} ke ${paymentMethodData.type} (${paymentMethodData.accountNumber})`,
          refId: redeemRef.id,
          refType: "redeem_request",
          metadata: {
            amount,
            destMethodId,
            destMethodType: paymentMethodData.type,
            destAccountNumber: paymentMethodData.accountNumber,
            refNumber,
          },
          createdAt: now,
          balanceAfter: newBalance,
        });

        return {
          success: true,
          requestId: redeemRef.id,
          pointsDeducted: pointsRequired,
          newBalance,
          estimatedProcessing: "1-3 hari kerja",
        };
      });

      // ========== SEND NOTIFICATION (outside transaction) ==========

      try {
        await collections.notifications.add({
          userId: uid,
          title: "Permintaan Pencairan Diterima",
          body: `Pencairan sebesar Rp ${amount.toLocaleString(
            "id-ID"
          )} sedang diproses. Estimasi 1-3 hari kerja.`,
          type: "redeem_pending",
          read: false,
          data: {
            type: "redeem_balance",
            requestId: result.requestId,
            amount,
            pointsDeducted: pointsRequired,
          },
          createdAt: admin.firestore.Timestamp.now(),
        });
      } catch (error) {
        console.error("Failed to send notification:", error);
        // Don't fail the whole operation
      }

      return result;
    }
  );

  return existingResult;
});
