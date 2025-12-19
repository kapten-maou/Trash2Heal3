import * as admin from "firebase-admin";

// Initialize if not already done
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const messaging = admin.messaging();

// ============================================
// TYPES & INTERFACES
// ============================================

export interface NotificationPayload {
  title: string;
  body: string;
  imageUrl?: string;
  data?: { [key: string]: string };
}

export interface NotificationRecord {
  id: string;
  userId: string;
  title: string;
  body: string;
  type: "pickup" | "points" | "event" | "membership" | "chat" | "system";
  data?: { [key: string]: any };
  imageUrl?: string;
  isRead: boolean;
  createdAt: FirebaseFirestore.Timestamp;
}

// ============================================
// SEND FCM TO USER
// ============================================

/**
 * Send FCM notification to a specific user
 *
 * @param userId - User ID to send notification to
 * @param payload - Notification content
 * @returns Success status
 */
export async function sendNotificationToUser(
  userId: string,
  payload: NotificationPayload
): Promise<boolean> {
  try {
    // 1. Get user's FCM tokens
    const userDoc = await db.collection("users").doc(userId).get();

    if (!userDoc.exists) {
      console.error(`User ${userId} not found`);
      return false;
    }

    const userData = userDoc.data();
    const fcmTokens: string[] = userData?.fcmTokens || [];

    if (fcmTokens.length === 0) {
      console.warn(`User ${userId} has no FCM tokens`);
      return false;
    }

    // 2. Save to notifications collection
    await saveNotification(userId, payload);

    // 3. Send FCM to all user's devices
    const message: admin.messaging.MulticastMessage = {
      tokens: fcmTokens,
      notification: {
        title: payload.title,
        body: payload.body,
        imageUrl: payload.imageUrl,
      },
      data: payload.data || {},
      android: {
        priority: "high",
        notification: {
          channelId: "default",
          sound: "default",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    };

    const response = await messaging.sendMulticast(message);

    // 4. Remove invalid tokens
    if (response.failureCount > 0) {
      await removeInvalidTokens(userId, fcmTokens, response);
    }

    console.log(
      `✅ Sent notification to user ${userId}: ${response.successCount}/${fcmTokens.length}`
    );
    return response.successCount > 0;
  } catch (error) {
    console.error("Error sending notification to user:", error);
    return false;
  }
}

// ============================================
// SEND FCM TO TOPIC
// ============================================

/**
 * Send FCM notification to a topic
 *
 * @param topic - Topic name (e.g., 'all_users', 'couriers')
 * @param payload - Notification content
 * @returns Success status
 */
export async function sendNotificationToTopic(
  topic: string,
  payload: NotificationPayload
): Promise<boolean> {
  try {
    const message: admin.messaging.Message = {
      topic: topic,
      notification: {
        title: payload.title,
        body: payload.body,
        imageUrl: payload.imageUrl,
      },
      data: payload.data || {},
      android: {
        priority: "high",
        notification: {
          channelId: "default",
          sound: "default",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
          },
        },
      },
    };

    await messaging.send(message);
    console.log(`✅ Sent notification to topic: ${topic}`);
    return true;
  } catch (error) {
    console.error("Error sending notification to topic:", error);
    return false;
  }
}

// ============================================
// SEND FCM TO MULTIPLE USERS
// ============================================

/**
 * Send FCM notification to multiple users
 *
 * @param userIds - Array of user IDs
 * @param payload - Notification content
 * @returns Number of successful sends
 */
export async function sendNotificationToMultipleUsers(
  userIds: string[],
  payload: NotificationPayload
): Promise<number> {
  let successCount = 0;

  // Process in batches of 500 (FCM limit)
  const batchSize = 500;
  for (let i = 0; i < userIds.length; i += batchSize) {
    const batch = userIds.slice(i, i + batchSize);

    const results = await Promise.all(
      batch.map((userId) => sendNotificationToUser(userId, payload))
    );

    successCount += results.filter((r) => r).length;
  }

  console.log(`✅ Sent to ${successCount}/${userIds.length} users`);
  return successCount;
}

// ============================================
// SAVE NOTIFICATION TO FIRESTORE
// ============================================

/**
 * Save notification record to Firestore
 */
async function saveNotification(
  userId: string,
  payload: NotificationPayload
): Promise<void> {
  const notificationRef = db.collection("notifications").doc();

  // Determine notification type from data
  const type = payload.data?.type || "system";

  const notification: Omit<NotificationRecord, "id"> = {
    userId,
    title: payload.title,
    body: payload.body,
    type: type as NotificationRecord["type"],
    data: payload.data,
    imageUrl: payload.imageUrl,
    isRead: false,
    createdAt:
      admin.firestore.FieldValue.serverTimestamp() as FirebaseFirestore.Timestamp,
  };

  await notificationRef.set(notification);
}

// ============================================
// REMOVE INVALID TOKENS
// ============================================

/**
 * Remove invalid/expired FCM tokens from user document
 */
async function removeInvalidTokens(
  userId: string,
  tokens: string[],
  response: admin.messaging.BatchResponse
): Promise<void> {
  const invalidTokens: string[] = [];

  response.responses.forEach((resp, idx) => {
    if (!resp.success) {
      const errorCode = resp.error?.code;
      if (
        errorCode === "messaging/invalid-registration-token" ||
        errorCode === "messaging/registration-token-not-registered"
      ) {
        invalidTokens.push(tokens[idx]);
      }
    }
  });

  if (invalidTokens.length > 0) {
    console.log(
      `Removing ${invalidTokens.length} invalid tokens from user ${userId}`
    );

    await db
      .collection("users")
      .doc(userId)
      .update({
        fcmTokens: admin.firestore.FieldValue.arrayRemove(...invalidTokens),
      });
  }
}

// ============================================
// HELPER: Get Notification Icon by Type
// ============================================

export function getNotificationIcon(type: string): string {
  const icons: { [key: string]: string } = {
    pickup: "🚛",
    points: "⭐",
    event: "🎉",
    membership: "👑",
    chat: "💬",
    system: "🔔",
  };
  return icons[type] || "🔔";
}

// ============================================
// HELPER: Format Notification Message
// ============================================

export function formatNotificationMessage(
  type: string,
  status?: string,
  data?: any
): { title: string; body: string } {
  const icon = getNotificationIcon(type);

  switch (type) {
    case "pickup":
      return formatPickupNotification(status!, data);
    case "points":
      return formatPointsNotification(status!, data);
    case "event":
      return formatEventNotification(status!, data);
    case "membership":
      return formatMembershipNotification(status!, data);
    case "chat":
      return {
        title: `${icon} Pesan Baru`,
        body: data?.message || "Anda mendapat pesan baru",
      };
    default:
      return {
        title: `${icon} Notifikasi`,
        body: data?.message || "Anda mendapat notifikasi baru",
      };
  }
}

function formatPickupNotification(
  status: string,
  data?: any
): { title: string; body: string } {
  const messages: { [key: string]: { title: string; body: string } } = {
    confirmed: {
      title: "✅ Pickup Dikonfirmasi",
      body: `Pickup Anda telah dikonfirmasi untuk ${data?.date || "hari ini"}`,
    },
    assigned: {
      title: "🚛 Kurir Ditugaskan",
      body: `Kurir ${data?.courierName || "kami"} akan mengambil sampah Anda`,
    },
    on_the_way: {
      title: "🚗 Kurir Dalam Perjalanan",
      body: `Kurir ${data?.courierName || ""} sedang menuju lokasi Anda`,
    },
    arrived: {
      title: "📍 Kurir Telah Tiba",
      body: "Kurir sudah sampai di lokasi pickup",
    },
    picked_up: {
      title: "✅ Sampah Telah Diambil",
      body: `Sampah seberat ${data?.weight || 0} kg telah diambil`,
    },
    completed: {
      title: "🎉 Pickup Selesai",
      body: `Anda mendapat ${
        data?.points || 0
      } poin! Terima kasih sudah berkontribusi`,
    },
    canceled: {
      title: "❌ Pickup Dibatalkan",
      body: data?.reason || "Pickup telah dibatalkan",
    },
  };

  return (
    messages[status] || { title: "🔔 Pickup Update", body: `Status: ${status}` }
  );
}

function formatPointsNotification(
  status: string,
  data?: any
): { title: string; body: string } {
  const messages: { [key: string]: { title: string; body: string } } = {
    earned: {
      title: "⭐ Poin Diterima",
      body: `Anda mendapat ${data?.points || 0} poin dari pickup`,
    },
    redeemed: {
      title: "🎁 Penukaran Berhasil",
      body: `${data?.points || 0} poin ditukar menjadi ${
        data?.coupons || 0
      } kupon`,
    },
    withdrawn: {
      title: "💰 Pencairan Diproses",
      body: `Pencairan Rp ${
        data?.amount?.toLocaleString("id-ID") || 0
      } sedang diproses`,
    },
    withdrawal_completed: {
      title: "✅ Pencairan Berhasil",
      body: `Rp ${
        data?.amount?.toLocaleString("id-ID") || 0
      } telah ditransfer ke rekening Anda`,
    },
    withdrawal_failed: {
      title: "❌ Pencairan Gagal",
      body: data?.reason || "Pencairan gagal, silakan hubungi admin",
    },
  };

  return (
    messages[status] || { title: "⭐ Poin Update", body: `Status: ${status}` }
  );
}

function formatEventNotification(
  status: string,
  data?: any
): { title: string; body: string } {
  const messages: { [key: string]: { title: string; body: string } } = {
    new_event: {
      title: "🎉 Event Baru!",
      body: `${
        data?.eventName || "Event baru"
      } tersedia. Tukar kupon sekarang!`,
    },
    coupon_redeemed: {
      title: "✅ Kupon Ditukar",
      body: `Kupon Anda telah ditukar untuk ${data?.itemName || "item"}`,
    },
    event_reminder: {
      title: "⏰ Event Akan Berakhir",
      body: `${data?.eventName || "Event"} akan berakhir dalam ${
        data?.daysLeft || 0
      } hari`,
    },
  };

  return (
    messages[status] || { title: "🎉 Event Update", body: `Status: ${status}` }
  );
}

function formatMembershipNotification(
  status: string,
  data?: any
): { title: string; body: string } {
  const messages: { [key: string]: { title: string; body: string } } = {
    activated: {
      title: "👑 Membership Aktif",
      body: `Selamat! ${data?.planName || "Membership"} Anda telah aktif`,
    },
    expiring_soon: {
      title: "⏰ Membership Akan Berakhir",
      body: `${data?.planName || "Membership"} Anda akan berakhir dalam ${
        data?.daysLeft || 0
      } hari`,
    },
    expired: {
      title: "❌ Membership Berakhir",
      body: `${
        data?.planName || "Membership"
      } Anda telah berakhir. Perpanjang sekarang!`,
    },
    payment_success: {
      title: "✅ Pembayaran Berhasil",
      body: `Pembayaran ${data?.planName || "membership"} berhasil`,
    },
    payment_failed: {
      title: "❌ Pembayaran Gagal",
      body: "Pembayaran membership gagal. Silakan coba lagi",
    },
  };

  return (
    messages[status] || {
      title: "👑 Membership Update",
      body: `Status: ${status}`,
    }
  );
}

// ============================================
// EXPORTS
// ============================================

export const fcmUtils = {
  sendNotificationToUser,
  sendNotificationToTopic,
  sendNotificationToMultipleUsers,
  getNotificationIcon,
  formatNotificationMessage,
};
