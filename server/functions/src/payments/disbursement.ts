/**
 * TRASH2HEAL Disbursement System
 *
 * This module handles cashout processing for users who redeem points to balance.
 *
 * Features:
 * - Mock bank transfer simulation
 * - Manual processing (admin-only)
 * - Automated scheduled processing
 * - Update redeem_requests status flow
 * - FCM notifications
 * - Admin statistics
 *
 * Status Flow:
 * pending → processing → completed (success)
 *                     ↘ failed (error)
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { requireAuth, requireRole } from "../utils/auth";
import { collections } from "../utils/firestore";
import * as admin from "firebase-admin";

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

interface ProcessDisbursementRequest {
  requestId: string;
}

interface ProcessDisbursementResponse {
  success: boolean;
  requestId: string;
  status: string;
  transferId?: string;
  message: string;
}

// ============================================================================
// MOCK BANK TRANSFER SIMULATION
// ============================================================================

/**
 * Generate unique transfer ID
 * Format: TRF{timestamp}{random}
 *
 * Example: TRF170012345612345
 */
function generateTransferId(): string {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 100000)
    .toString()
    .padStart(5, "0");
  return `TRF${timestamp}${random}`;
}

/**
 * Simulate bank transfer (MOCK)
 *
 * In production, replace this with actual payment gateway API:
 * - Xendit: disbursement API
 * - Midtrans: payout API
 * - OY!: send money API
 *
 * Current simulation:
 * - 95% success rate
 * - 1 second delay (simulating API call)
 * - Random transfer ID on success
 *
 * @param amount - Transfer amount in IDR
 * @param accountNumber - Destination account number
 * @param accountName - Destination account name
 * @param bankName - Bank name or e-wallet type
 * @returns Transfer result with success flag and transfer ID or error
 */
async function executeBankTransfer(
  amount: number,
  accountNumber: string,
  accountName: string,
  bankName: string
): Promise<{
  success: boolean;
  transferId?: string;
  error?: string;
}> {
  console.log(
    `💸 Executing mock transfer: Rp ${amount.toLocaleString(
      "id-ID"
    )} → ${bankName} ${accountNumber} (${accountName})`
  );

  // Simulate API call delay (1 second)
  await new Promise((resolve) => setTimeout(resolve, 1000));

  // Mock success rate: 95%
  // In production, actual API calls may fail due to:
  // - Bank maintenance
  // - Invalid account
  // - Insufficient funds
  // - Network timeout
  const success = Math.random() > 0.05;

  if (success) {
    const transferId = generateTransferId();
    console.log(`✅ Transfer successful: ${transferId}`);
    return {
      success: true,
      transferId,
    };
  } else {
    const errorMessage = "Transfer gagal. Bank sedang dalam maintenance.";
    console.log(`❌ Transfer failed: ${errorMessage}`);
    return {
      success: false,
      error: errorMessage,
    };
  }
}

// ============================================================================
// NOTIFICATION HELPERS
// ============================================================================

/**
 * Send FCM notification for disbursement result
 *
 * @param userId - User ID
 * @param status - Result status ("success" or "failed")
 * @param amount - Transfer amount
 * @param accountNumber - Destination account
 * @param reason - Failure reason (optional)
 */
async function sendDisbursementNotification(
  userId: string,
  status: "success" | "failed",
  amount: number,
  accountNumber: string,
  reason?: string
): Promise<void> {
  try {
    const title =
      status === "success" ? "✅ Pencairan Berhasil" : "❌ Pencairan Gagal";

    const body =
      status === "success"
        ? `Pencairan sebesar Rp ${amount.toLocaleString(
            "id-ID"
          )} ke rekening ${accountNumber} berhasil diproses.`
        : `Pencairan sebesar Rp ${amount.toLocaleString("id-ID")} gagal. ${
            reason || "Silakan coba lagi."
          }`;

    await collections.notifications.add({
      userId,
      title,
      body,
      type:
        status === "success" ? "disbursement_success" : "disbursement_failed",
      read: false,
      data: {
        type: "disbursement",
        status,
        amount,
        accountNumber,
        reason,
      },
      createdAt: admin.firestore.Timestamp.now(),
    });

    console.log(`✅ Notification sent: ${userId} → disbursement_${status}`);
  } catch (error) {
    console.error("❌ Failed to send notification:", error);
    // Don't throw - notification is best effort
  }
}

// ============================================================================
// MANUAL DISBURSEMENT (ADMIN ONLY)
// ============================================================================

/**
 * Process single disbursement request manually
 *
 * This is a callable function that can be triggered by admin users
 * through the admin dashboard or API.
 *
 * Flow:
 * 1. Verify admin role
 * 2. Get redeem_request document
 * 3. Validate status is "pending"
 * 4. Update status to "processing"
 * 5. Execute mock bank transfer
 * 6. If success:
 *    - Update status to "completed"
 *    - Set transferId
 *    - Set completedAt timestamp
 *    - Send success notification
 * 7. If failed:
 *    - Update status to "failed"
 *    - Set failureReason
 *    - Set failedAt timestamp
 *    - Send failure notification
 * 8. On error: rollback to "pending"
 *
 * @param request - Callable request with requestId
 * @returns Response with success status and transfer details
 */
export const processDisbursement = onCall<
  ProcessDisbursementRequest,
  Promise<ProcessDisbursementResponse>
>(async (request) => {
  const uid = requireAuth(request);

  // ========== VERIFY ADMIN ROLE ==========
  try {
    await requireRole(request, "admin");
  } catch (error) {
    throw new HttpsError(
      "permission-denied",
      "Only admins can process disbursements"
    );
  }

  console.log(`👤 Admin ${uid} processing disbursement manually`);

  const { requestId } = request.data;

  // ========== VALIDATE INPUT ==========
  if (!requestId || typeof requestId !== "string") {
    throw new HttpsError("invalid-argument", "Valid request ID is required");
  }

  // ========== GET REDEEM REQUEST ==========
  const redeemRef = collections.redeemRequests.doc(requestId);
  const redeemDoc = await redeemRef.get();

  if (!redeemDoc.exists) {
    throw new HttpsError("not-found", `Redeem request not found: ${requestId}`);
  }

  const redeemData = redeemDoc.data()!;

  // ========== VALIDATE STATUS ==========
  if (redeemData.status !== "pending") {
    throw new HttpsError(
      "failed-precondition",
      `Request already ${redeemData.status}. Only pending requests can be processed.`
    );
  }

  console.log(
    `📋 Processing request ${requestId} for user ${redeemData.userId}`
  );

  const now = admin.firestore.Timestamp.now();

  try {
    // ========== UPDATE STATUS TO PROCESSING ==========
    await redeemRef.update({
      status: "processing",
      processedAt: now,
      processedBy: uid,
    });

    console.log(`⏳ Status updated to "processing"`);

    // ========== EXECUTE BANK TRANSFER ==========
    const transferResult = await executeBankTransfer(
      redeemData.amount,
      redeemData.destAccountNumber,
      redeemData.destAccountName,
      redeemData.destMethodType
    );

    // ========== HANDLE SUCCESS ==========
    if (transferResult.success) {
      // Update to completed
      await redeemRef.update({
        status: "completed",
        completedAt: now,
        transferId: transferResult.transferId,
      });

      console.log(`✅ Status updated to "completed"`);

      // Send success notification
      await sendDisbursementNotification(
        redeemData.userId,
        "success",
        redeemData.amount,
        redeemData.destAccountNumber
      );

      console.log(
        `🎉 Disbursement completed: ${requestId} → ${transferResult.transferId}`
      );

      return {
        success: true,
        requestId,
        status: "completed",
        transferId: transferResult.transferId,
        message: "Disbursement completed successfully",
      };
    }
    // ========== HANDLE FAILURE ==========
    else {
      // Update to failed
      await redeemRef.update({
        status: "failed",
        failedAt: now,
        failureReason: transferResult.error,
      });

      console.log(`❌ Status updated to "failed"`);

      // Send failure notification
      await sendDisbursementNotification(
        redeemData.userId,
        "failed",
        redeemData.amount,
        redeemData.destAccountNumber,
        transferResult.error
      );

      console.log(
        `⚠️ Disbursement failed: ${requestId} → ${transferResult.error}`
      );

      throw new HttpsError(
        "internal",
        `Disbursement failed: ${transferResult.error}`
      );
    }
  } catch (error: any) {
    console.error(`❌ Error during disbursement: ${error.message}`);

    // ========== ROLLBACK TO PENDING ==========
    await redeemRef.update({
      status: "pending",
      processedAt: null,
      processedBy: null,
    });

    console.log(`🔄 Rolled back to "pending" status`);

    throw new HttpsError(
      "internal",
      `Failed to process disbursement: ${error.message}`
    );
  }
});

// ============================================================================
// AUTOMATED DISBURSEMENT (SCHEDULED)
// ============================================================================

/**
 * Automatically process pending disbursement requests
 *
 * Schedule: Every day at 10:00 AM WIB (03:00 UTC)
 *
 * This function:
 * 1. Queries all pending redeem_requests
 * 2. Filters requests older than 24 hours
 * 3. Processes max 50 requests per run
 * 4. For each request:
 *    - Updates status to "processing"
 *    - Executes mock bank transfer
 *    - Updates status to "completed" or "failed"
 *    - Sends notification
 * 5. Adds 2-second delay between requests
 * 6. Logs success/failure counts
 *
 * Why 24-hour delay?
 * - Gives users time to cancel if needed
 * - Reduces processing load
 * - Standard practice for batch disbursements
 */
export const autoDisbursement = onSchedule(
  {
    schedule: "0 3 * * *", // Daily at 03:00 UTC (10:00 WIB)
    timeZone: "Asia/Jakarta",
  },
  async () => {
    console.log("🤖 Auto-disbursement started...");

    try {
      // ========== QUERY PENDING REQUESTS ==========
      const snapshot = await collections.redeemRequests
        .where("status", "==", "pending")
        .orderBy("createdAt", "asc") // Oldest first
        .limit(50) // Max 50 per run
        .get();

      if (snapshot.empty) {
        console.log("✅ No pending disbursements found");
        return;
      }

      console.log(`📦 Found ${snapshot.size} pending disbursement(s)`);

      let successCount = 0;
      let failedCount = 0;
      let skippedCount = 0;

      // ========== PROCESS EACH REQUEST ==========
      for (const doc of snapshot.docs) {
        const redeemData = doc.data();
        const requestId = doc.id;

        // ========== CHECK AGE (must be > 24h old) ==========
        const createdAt = redeemData.createdAt.toMillis();
        const now = Date.now();
        const ageHours = (now - createdAt) / (1000 * 60 * 60);

        if (ageHours < 24) {
          console.log(
            `⏭️ Skipping ${requestId}: too new (${ageHours.toFixed(
              1
            )}h old, need 24h)`
          );
          skippedCount++;
          continue;
        }

        console.log(`📋 Processing ${requestId} (${ageHours.toFixed(1)}h old)`);

        try {
          const nowTimestamp = admin.firestore.Timestamp.now();

          // ========== UPDATE TO PROCESSING ==========
          await doc.ref.update({
            status: "processing",
            processedAt: nowTimestamp,
            processedBy: "auto_system",
          });

          // ========== EXECUTE TRANSFER ==========
          const transferResult = await executeBankTransfer(
            redeemData.amount,
            redeemData.destAccountNumber,
            redeemData.destAccountName,
            redeemData.destMethodType
          );

          // ========== HANDLE RESULT ==========
          if (transferResult.success) {
            // Update to completed
            await doc.ref.update({
              status: "completed",
              completedAt: nowTimestamp,
              transferId: transferResult.transferId,
            });

            // Send notification
            await sendDisbursementNotification(
              redeemData.userId,
              "success",
              redeemData.amount,
              redeemData.destAccountNumber
            );

            successCount++;
            console.log(
              `✅ ${requestId} completed: ${transferResult.transferId}`
            );
          } else {
            // Update to failed
            await doc.ref.update({
              status: "failed",
              failedAt: nowTimestamp,
              failureReason: transferResult.error,
            });

            // Send notification
            await sendDisbursementNotification(
              redeemData.userId,
              "failed",
              redeemData.amount,
              redeemData.destAccountNumber,
              transferResult.error
            );

            failedCount++;
            console.log(`❌ ${requestId} failed: ${transferResult.error}`);
          }
        } catch (error: any) {
          failedCount++;
          console.error(`❌ Error processing ${requestId}:`, error);

          // Rollback to pending
          await doc.ref.update({
            status: "pending",
            processedAt: null,
            processedBy: null,
          });

          console.log(`🔄 ${requestId} rolled back to pending`);
        }

        // ========== DELAY BETWEEN REQUESTS ==========
        // Prevents overwhelming the system and payment gateway
        await new Promise((resolve) => setTimeout(resolve, 2000));
      }

      // ========== SUMMARY ==========
      console.log("━".repeat(50));
      console.log("🎉 Auto-disbursement complete!");
      console.log(`✅ Succeeded: ${successCount}`);
      console.log(`❌ Failed: ${failedCount}`);
      console.log(`⏭️ Skipped (too new): ${skippedCount}`);
      console.log("━".repeat(50));
    } catch (error) {
      console.error("❌ Auto-disbursement error:", error);
    }
  }
);

// ============================================================================
// ADMIN STATISTICS
// ============================================================================

/**
 * Get disbursement statistics (Admin only)
 *
 * Returns:
 * - Counts by status (pending, processing, completed, failed, total)
 * - Total amounts (total, completed, pending)
 *
 * @returns Statistics object
 */
export const getDisbursementStats = onCall(async (request) => {
  const uid = requireAuth(request);

  // ========== VERIFY ADMIN ROLE ==========
  try {
    await requireRole(request, "admin");
  } catch (error) {
    throw new HttpsError(
      "permission-denied",
      "Only admins can view disbursement statistics"
    );
  }

  console.log(`📊 Admin ${uid} requesting disbursement stats`);

  try {
    // ========== GET COUNTS BY STATUS ==========
    const [pendingSnap, processingSnap, completedSnap, failedSnap] =
      await Promise.all([
        collections.redeemRequests
          .where("status", "==", "pending")
          .count()
          .get(),
        collections.redeemRequests
          .where("status", "==", "processing")
          .count()
          .get(),
        collections.redeemRequests
          .where("status", "==", "completed")
          .count()
          .get(),
        collections.redeemRequests
          .where("status", "==", "failed")
          .count()
          .get(),
      ]);

    // ========== CALCULATE AMOUNTS ==========
    const allRequests = await collections.redeemRequests.get();
    let totalAmount = 0;
    let completedAmount = 0;
    let pendingAmount = 0;

    allRequests.forEach((doc) => {
      const data = doc.data();
      totalAmount += data.amount;

      if (data.status === "completed") {
        completedAmount += data.amount;
      } else if (data.status === "pending") {
        pendingAmount += data.amount;
      }
    });

    const stats = {
      counts: {
        pending: pendingSnap.data().count,
        processing: processingSnap.data().count,
        completed: completedSnap.data().count,
        failed: failedSnap.data().count,
        total: allRequests.size,
      },
      amounts: {
        total: totalAmount,
        completed: completedAmount,
        pending: pendingAmount,
      },
    };

    console.log(`✅ Stats retrieved:`, stats);

    return stats;
  } catch (error: any) {
    console.error(`❌ Failed to get stats:`, error);
    throw new HttpsError(
      "internal",
      `Failed to get statistics: ${error.message}`
    );
  }
});
