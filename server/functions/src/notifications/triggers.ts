import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { sendNotificationToUser, formatNotificationMessage } from "./sendFcm";

// Initialize if not already done
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// ============================================
// TRIGGER 1: Pickup Request Status Change
// ============================================

/**
 * Send notification when pickup request status changes
 *
 * Triggers: requested → confirmed → assigned → canceled
 */
export const onPickupRequestChange = functions.firestore
  .document("pickup_requests/{requestId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if status changed
    if (before.status === after.status) {
      return null;
    }

    const newStatus = after.status;
    const userId = after.userId;

    console.log(
      `Pickup request ${context.params.requestId}: ${before.status} → ${newStatus}`
    );

    // Format notification message
    const notification = formatNotificationMessage("pickup", newStatus, {
      date: after.pickupDate?.toDate().toLocaleDateString("id-ID"),
      courierName: after.courierName,
      requestId: context.params.requestId,
    });

    // Send notification
    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "pickup",
        status: newStatus,
        requestId: context.params.requestId,
        screen: "/pickup/detail",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 2: Pickup Task Status Change
// ============================================

/**
 * Send notification when pickup task status changes (for user)
 *
 * Triggers: assigned → on_the_way → arrived → picked_up → completed
 */
export const onPickupTaskChange = functions.firestore
  .document("pickup_tasks/{taskId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if status changed
    if (before.status === after.status) {
      return null;
    }

    const newStatus = after.status;
    const userId = after.userId;

    console.log(
      `Pickup task ${context.params.taskId}: ${before.status} → ${newStatus}`
    );

    // Format notification message
    const notification = formatNotificationMessage("pickup", newStatus, {
      courierName: after.courierName,
      weight: after.actualWeight,
      points: after.pointsEarned,
      taskId: context.params.taskId,
    });

    // Send to user
    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "pickup",
        status: newStatus,
        taskId: context.params.taskId,
        screen: "/pickup/detail",
      },
    });

    // If completed, also notify courier
    if (newStatus === "completed") {
      const courierNotification = {
        title: "✅ Pickup Selesai",
        body: `Task #${context.params.taskId.substring(
          0,
          8
        )} telah diselesaikan`,
      };

      await sendNotificationToUser(after.courierId, {
        title: courierNotification.title,
        body: courierNotification.body,
        data: {
          type: "pickup",
          status: "completed",
          taskId: context.params.taskId,
          screen: "/courier/tasks",
        },
      });
    }

    return null;
  });

// ============================================
// TRIGGER 3: Points Earned (New Entry in Ledger)
// ============================================

/**
 * Send notification when user earns points
 */
export const onPointsEarned = functions.firestore
  .document("point_ledger/{ledgerId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    // Only for 'earn' type
    if (data.type !== "earn") {
      return null;
    }

    const userId = data.userId;
    const points = data.amount;

    console.log(`User ${userId} earned ${points} points`);

    const notification = formatNotificationMessage("points", "earned", {
      points,
      source: data.source,
    });

    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "points",
        status: "earned",
        points: points.toString(),
        screen: "/points",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 4: Redeem Request Status Change
// ============================================

/**
 * Send notification when redeem request status changes
 *
 * Triggers: pending → processing → completed/failed
 */
export const onRedeemRequestChange = functions.firestore
  .document("redeem_requests/{requestId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if status changed
    if (before.status === after.status) {
      return null;
    }

    const newStatus = after.status;
    const userId = after.userId;

    console.log(
      `Redeem request ${context.params.requestId}: ${before.status} → ${newStatus}`
    );

    // Map status to notification type
    const statusMap: { [key: string]: string } = {
      processing: "withdrawn",
      completed: "withdrawal_completed",
      failed: "withdrawal_failed",
    };

    const notifStatus = statusMap[newStatus] || newStatus;

    const notification = formatNotificationMessage("points", notifStatus, {
      amount: after.amount,
      reason: after.failureReason,
      requestId: context.params.requestId,
    });

    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "points",
        status: newStatus,
        requestId: context.params.requestId,
        screen: "/profile/wallet",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 5: Coupon Redeemed (Voucher Scan)
// ============================================

/**
 * Send notification when coupon is redeemed at event
 */
export const onCouponRedeemed = functions.firestore
  .document("voucher_scans/{scanId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    const userId = data.userId;

    console.log(`Coupon ${data.couponCode} redeemed by user ${userId}`);

    // Get event and item details
    const [eventDoc, itemDoc] = await Promise.all([
      db.collection("events").doc(data.eventId).get(),
      db.collection("event_items").doc(data.eventItemId).get(),
    ]);

    const eventName = eventDoc.exists ? eventDoc.data()?.name : "Event";
    const itemName = itemDoc.exists ? itemDoc.data()?.name : "Item";

    const notification = formatNotificationMessage("event", "coupon_redeemed", {
      eventName,
      itemName,
      couponCode: data.couponCode,
    });

    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "event",
        status: "redeemed",
        eventId: data.eventId,
        screen: "/events/my",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 6: Membership Status Change
// ============================================

/**
 * Send notification when membership status changes
 */
export const onMembershipChange = functions.firestore
  .document("users/{userId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    const userId = context.params.userId;

    // Check membership status change
    const beforeStatus = before.membership?.status;
    const afterStatus = after.membership?.status;

    if (beforeStatus === afterStatus) {
      return null;
    }

    console.log(`User ${userId} membership: ${beforeStatus} → ${afterStatus}`);

    const planName = after.membership?.planName || "Membership";

    const notification = formatNotificationMessage("membership", afterStatus, {
      planName,
      expiresAt: after.membership?.expiresAt
        ?.toDate()
        .toLocaleDateString("id-ID"),
    });

    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "membership",
        status: afterStatus,
        screen: "/member",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 7: Payment Status Change
// ============================================

/**
 * Send notification when payment status changes
 */
export const onPaymentChange = functions.firestore
  .document("payments/{paymentId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // Check if status changed
    if (before.status === after.status) {
      return null;
    }

    const newStatus = after.status;
    const userId = after.userId;

    // Only notify on success or failure
    if (newStatus !== "success" && newStatus !== "failed") {
      return null;
    }

    console.log(
      `Payment ${context.params.paymentId}: ${before.status} → ${newStatus}`
    );

    const notifStatus =
      newStatus === "success" ? "payment_success" : "payment_failed";

    const notification = formatNotificationMessage("membership", notifStatus, {
      planName: after.metadata?.planName || "Membership",
      amount: after.amount,
    });

    await sendNotificationToUser(userId, {
      title: notification.title,
      body: notification.body,
      data: {
        type: "membership",
        status: newStatus,
        paymentId: context.params.paymentId,
        screen: "/member",
      },
    });

    return null;
  });

// ============================================
// TRIGGER 8: New Event Created
// ============================================

/**
 * Notify all users when new event is created
 */
export const onNewEvent = functions.firestore
  .document("events/{eventId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    // Only notify for active events
    if (data.status !== "active") {
      return null;
    }

    console.log(`New event created: ${data.name}`);

    const notification = formatNotificationMessage("event", "new_event", {
      eventName: data.name,
      eventId: context.params.eventId,
    });

    // Send to all users topic
    await sendNotificationToUser("all_users", {
      title: notification.title,
      body: notification.body,
      imageUrl: data.imageUrl,
      data: {
        type: "event",
        status: "new",
        eventId: context.params.eventId,
        screen: `/events/${context.params.eventId}`,
      },
    });

    return null;
  });

// ============================================
// SCHEDULED: Membership Expiry Reminder
// ============================================

/**
 * Daily check for memberships expiring soon (3 days before)
 * Runs every day at 10:00 AM Jakarta time
 */
export const membershipExpiryReminder = functions.pubsub
  .schedule("0 10 * * *")
  .timeZone("Asia/Jakarta")
  .onRun(async (context) => {
    console.log("Running membership expiry reminder check...");

    const threeDaysFromNow = new Date();
    threeDaysFromNow.setDate(threeDaysFromNow.getDate() + 3);
    threeDaysFromNow.setHours(23, 59, 59, 999);

    // Get users with membership expiring in 3 days
    const usersSnapshot = await db
      .collection("users")
      .where("membership.status", "==", "active")
      .where(
        "membership.expiresAt",
        "<=",
        admin.firestore.Timestamp.fromDate(threeDaysFromNow)
      )
      .get();

    console.log(`Found ${usersSnapshot.size} memberships expiring soon`);

    const notifications = usersSnapshot.docs.map(async (doc) => {
      const userId = doc.id;
      const userData = doc.data();
      const membership = userData.membership;

      const daysLeft = Math.ceil(
        (membership.expiresAt.toDate().getTime() - Date.now()) /
          (1000 * 60 * 60 * 24)
      );

      if (daysLeft <= 3 && daysLeft > 0) {
        const notification = formatNotificationMessage(
          "membership",
          "expiring_soon",
          {
            planName: membership.planName,
            daysLeft,
          }
        );

        await sendNotificationToUser(userId, {
          title: notification.title,
          body: notification.body,
          data: {
            type: "membership",
            status: "expiring_soon",
            daysLeft: daysLeft.toString(),
            screen: "/member",
          },
        });
      }
    });

    await Promise.all(notifications);

    console.log("✅ Membership expiry reminders sent");
    return null;
  });

// ============================================
// EXPORTS
// ============================================

export const notificationTriggers = {
  onPickupRequestChange,
  onPickupTaskChange,
  onPointsEarned,
  onRedeemRequestChange,
  onCouponRedeemed,
  onMembershipChange,
  onPaymentChange,
  onNewEvent,
  membershipExpiryReminder,
};
