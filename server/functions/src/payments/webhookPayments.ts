import { onRequest } from "firebase-functions/v2/https";
import { collections, runTransaction } from "../utils/firestore";
import * as admin from "firebase-admin";
import * as crypto from "crypto";

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

interface WebhookPayload {
  paymentId: string;
  amount: number;
  status: "success" | "failed";
  signature: string;
  transactionId?: string;
  paidAt?: string;
}

// ============================================================================
// MEMBERSHIP PLANS CONFIGURATION
// ============================================================================

const MEMBERSHIP_PLANS = {
  silver: {
    name: "Silver",
    price: 49000,
    durationDays: 30,
    multiplier: 1.2,
    bonusPoints: 500,
  },
  gold: {
    name: "Gold",
    price: 129000,
    durationDays: 90,
    multiplier: 1.5,
    bonusPoints: 1500,
  },
  platinum: {
    name: "Platinum",
    price: 449000,
    durationDays: 365,
    multiplier: 2.0,
    bonusPoints: 5000,
  },
};

// ============================================================================
// SIGNATURE VERIFICATION
// ============================================================================

/**
 * Verify webhook signature using SHA-256
 * This prevents unauthorized webhook calls
 */
function verifySignature(
  paymentId: string,
  amount: number,
  signature: string
): boolean {
  const secret = "TRASH2HEAL_SECRET_KEY_2024"; // Store in environment
  const payload = `${paymentId}:${amount}:${secret}`;
  const expectedSignature = crypto
    .createHash("sha256")
    .update(payload)
    .digest("hex");

  return signature === expectedSignature;
}

// ============================================================================
// MEMBERSHIP ACTIVATION
// ============================================================================

/**
 * Calculate membership expiry date
 */
function calculateMembershipExpiry(durationDays: number): Date {
  const expiry = new Date();
  expiry.setDate(expiry.getDate() + durationDays);
  return expiry;
}

/**
 * Activate membership plan for user
 * Sets status, dates, multiplier, and awards bonus points
 */
async function activateMembership(
  userId: string,
  planId: string,
  paymentId: string
): Promise<void> {
  const plan = MEMBERSHIP_PLANS[planId as keyof typeof MEMBERSHIP_PLANS];
  if (!plan) {
    throw new Error(`Invalid plan ID: ${planId}`);
  }

  const now = admin.firestore.Timestamp.now();
  const startDate = new Date();
  const expiryDate = calculateMembershipExpiry(plan.durationDays);

  await runTransaction(async (transaction) => {
    const userRef = collections.users.doc(userId);
    const userDoc = await transaction.get(userRef);

    if (!userDoc.exists) {
      throw new Error(`User not found: ${userId}`);
    }

    const userData = userDoc.data()!;
    const currentBalance = userData.points?.balance || 0;

    // ========== UPDATE USER MEMBERSHIP ==========
    transaction.update(userRef, {
      "member.plan": planId,
      "member.status": "active",
      "member.startedAt": admin.firestore.Timestamp.fromDate(startDate),
      "member.expiresAt": admin.firestore.Timestamp.fromDate(expiryDate),
      "member.multiplier": plan.multiplier,
      "member.activatedAt": now,
      "member.lastPaymentId": paymentId,
    });

    // ========== AWARD BONUS POINTS ==========
    if (plan.bonusPoints > 0) {
      const newBalance = currentBalance + plan.bonusPoints;

      transaction.update(userRef, {
        "points.balance": newBalance,
        "points.totalEarned":
          (userData.points?.totalEarned || 0) + plan.bonusPoints,
      });

      // ========== WRITE TO POINT LEDGER ==========
      const ledgerRef = collections.pointLedger.doc();
      transaction.set(ledgerRef, {
        id: ledgerRef.id,
        userId,
        delta: plan.bonusPoints,
        reason: "membership_bonus",
        description: `Bonus ${plan.bonusPoints} poin dari aktivasi ${plan.name} membership`,
        refId: paymentId,
        refType: "payment",
        metadata: {
          planId,
          planName: plan.name,
          durationDays: plan.durationDays,
          multiplier: plan.multiplier,
        },
        createdAt: now,
        balanceAfter: newBalance,
      });
    }
  });

  console.log(
    `✅ Membership activated: ${userId} → ${plan.name} (${plan.durationDays} days)`
  );
}

// ============================================================================
// NOTIFICATION HELPERS
// ============================================================================

/**
 * Send FCM notification on successful activation
 */
async function sendActivationNotification(
  userId: string,
  planName: string,
  bonusPoints: number
): Promise<void> {
  try {
    await collections.notifications.add({
      userId,
      title: "🎉 Membership Aktif!",
      body: `Selamat! ${planName} membership Anda sudah aktif. Bonus ${bonusPoints} poin telah ditambahkan.`,
      type: "membership_active",
      read: false,
      data: {
        type: "membership_activated",
        planName,
        bonusPoints,
      },
      createdAt: admin.firestore.Timestamp.now(),
    });

    console.log(`✅ Notification sent: ${userId} → membership_active`);
  } catch (error) {
    console.error("❌ Failed to send notification:", error);
    // Don't throw, notification is best effort
  }
}

/**
 * Send FCM notification on payment failure
 */
async function sendFailureNotification(
  userId: string,
  planName: string,
  reason: string
): Promise<void> {
  try {
    await collections.notifications.add({
      userId,
      title: "❌ Pembayaran Gagal",
      body: `Pembayaran ${planName} membership gagal. ${reason}`,
      type: "payment_failed",
      read: false,
      data: {
        type: "payment_failed",
        planName,
        reason,
      },
      createdAt: admin.firestore.Timestamp.now(),
    });

    console.log(`✅ Notification sent: ${userId} → payment_failed`);
  } catch (error) {
    console.error("❌ Failed to send notification:", error);
  }
}

// ============================================================================
// WEBHOOK HANDLER
// ============================================================================

/**
 * Webhook endpoint for payment gateway callbacks
 * Endpoint: POST /webhookPayments
 *
 * This function:
 * 1. Verifies signature
 * 2. Validates payment data
 * 3. Activates membership on success
 * 4. Sets member.status = "active"
 * 5. Sets startedAt and expiresAt
 * 6. Awards bonus points
 * 7. Sends FCM notification
 */
export const webhookPayments = onRequest(async (req, res) => {
  // ========== METHOD VALIDATION ==========
  if (req.method !== "POST") {
    res.status(405).json({
      success: false,
      error: "Method not allowed. Use POST.",
    });
    return;
  }

  try {
    const payload: WebhookPayload = req.body;

    console.log(
      `📥 Webhook received: ${payload.paymentId} → ${payload.status}`
    );

    // ========== PAYLOAD VALIDATION ==========
    if (
      !payload.paymentId ||
      !payload.amount ||
      !payload.status ||
      !payload.signature
    ) {
      res.status(400).json({
        success: false,
        error: "Missing required fields: paymentId, amount, status, signature",
      });
      return;
    }

    // ========== GET PAYMENT RECORD ==========
    const paymentRef = collections.payments.doc(payload.paymentId);
    const paymentDoc = await paymentRef.get();

    if (!paymentDoc.exists) {
      res.status(404).json({
        success: false,
        error: `Payment not found: ${payload.paymentId}`,
      });
      return;
    }

    const paymentData = paymentDoc.data()!;

    // ========== VERIFY SIGNATURE ==========
    const isValid = verifySignature(
      payload.paymentId,
      payload.amount,
      payload.signature
    );

    if (!isValid) {
      console.error(`❌ Invalid signature for payment: ${payload.paymentId}`);
      res.status(401).json({
        success: false,
        error: "Invalid signature",
      });
      return;
    }

    console.log(`✅ Signature verified: ${payload.paymentId}`);

    // ========== CHECK IF ALREADY PROCESSED ==========
    if (paymentData.status !== "pending") {
      console.log(
        `⚠️ Payment already processed: ${payload.paymentId} (${paymentData.status})`
      );
      res.status(200).json({
        success: true,
        message: "Payment already processed",
        status: paymentData.status,
      });
      return;
    }

    // ========== VALIDATE AMOUNT ==========
    if (payload.amount !== paymentData.amount) {
      console.error(
        `❌ Amount mismatch: expected ${paymentData.amount}, got ${payload.amount}`
      );
      res.status(400).json({
        success: false,
        error: `Amount mismatch. Expected: ${paymentData.amount}, Got: ${payload.amount}`,
      });
      return;
    }

    const now = admin.firestore.Timestamp.now();

    // ========== HANDLE SUCCESS ==========
    if (payload.status === "success") {
      try {
        // Update payment status
        await paymentRef.update({
          status: "success",
          paidAt: now,
          transactionId: payload.transactionId || null,
          processedAt: now,
        });

        console.log(`✅ Payment marked as success: ${payload.paymentId}`);

        // Activate membership
        await activateMembership(
          paymentData.userId,
          paymentData.planId,
          payload.paymentId
        );

        // Send notification
        const plan =
          MEMBERSHIP_PLANS[paymentData.planId as keyof typeof MEMBERSHIP_PLANS];
        await sendActivationNotification(
          paymentData.userId,
          plan.name,
          plan.bonusPoints
        );

        console.log(
          `🎉 Membership activation complete: ${paymentData.userId} → ${plan.name}`
        );

        res.status(200).json({
          success: true,
          message: "Payment processed and membership activated",
          paymentId: payload.paymentId,
          userId: paymentData.userId,
        });
      } catch (error: any) {
        console.error(`❌ Error processing payment:`, error);

        // Update payment to failed
        await paymentRef.update({
          status: "failed",
          failureReason: error.message,
          processedAt: now,
        });

        res.status(500).json({
          success: false,
          error: "Failed to process payment",
          message: error.message,
        });
      }
    }
    // ========== HANDLE FAILURE ==========
    else if (payload.status === "failed") {
      await paymentRef.update({
        status: "failed",
        failureReason: "Payment failed from gateway",
        processedAt: now,
      });

      console.log(`❌ Payment marked as failed: ${payload.paymentId}`);

      // Send failure notification
      const plan =
        MEMBERSHIP_PLANS[paymentData.planId as keyof typeof MEMBERSHIP_PLANS];
      await sendFailureNotification(
        paymentData.userId,
        plan.name,
        "Pembayaran gagal diproses. Silakan coba lagi."
      );

      res.status(200).json({
        success: true,
        message: "Payment failure recorded",
        paymentId: payload.paymentId,
      });
    } else {
      res.status(400).json({
        success: false,
        error: `Invalid status: ${payload.status}`,
      });
    }
  } catch (error: any) {
    console.error("❌ Webhook error:", error);
    res.status(500).json({
      success: false,
      error: "Internal server error",
      message: error.message,
    });
  }
});
