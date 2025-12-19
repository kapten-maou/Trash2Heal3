import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { sendNotificationToUser } from "../notifications/sendFcm";

// Initialize if not already done
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// ============================================
// TRIGGER: New Chat Message
// ============================================

/**
 * Send FCM notification when new chat message is sent
 *
 * Triggers on: chat_messages/{threadId}/messages/{messageId} created
 */
export const onMessageWrite = functions.firestore
  .document("chat_threads/{threadId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    const message = snap.data();
    const threadId = context.params.threadId;
    const messageId = context.params.messageId;

    console.log(`New message in thread ${threadId} from ${message.senderId}`);

    try {
      // 1. Get thread details
      const threadDoc = await db.collection("chat_threads").doc(threadId).get();

      if (!threadDoc.exists) {
        console.error(`Thread ${threadId} not found`);
        return null;
      }

      const thread = threadDoc.data()!;

      // 2. Update thread's last message & timestamp
      await threadDoc.ref.update({
        lastMessage: message.text || "[Media]",
        lastMessageAt: message.createdAt,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // 3. Determine recipient (the other participant)
      const participants = thread.participants as string[];
      const recipientId = participants.find(
        (id: string) => id !== message.senderId
      );

      if (!recipientId) {
        console.error("No recipient found in thread");
        return null;
      }

      // 4. Get sender info
      const senderDoc = await db
        .collection("users")
        .doc(message.senderId)
        .get();
      const senderName = senderDoc.exists
        ? senderDoc.data()?.name || "User"
        : "User";

      // 5. Update unread count for recipient
      await updateUnreadCount(threadId, recipientId);

      // 6. Send FCM notification to recipient
      await sendNotificationToUser(recipientId, {
        title: `💬 ${senderName}`,
        body: message.text || "Mengirim media",
        imageUrl: message.imageUrl,
        data: {
          type: "chat",
          threadId: threadId,
          messageId: messageId,
          senderId: message.senderId,
          senderName: senderName,
          screen: `/chat/${threadId}`,
        },
      });

      console.log(
        `✅ Notification sent to ${recipientId} for message in thread ${threadId}`
      );

      return null;
    } catch (error) {
      console.error("Error handling new message:", error);
      return null;
    }
  });

// ============================================
// HELPER: Update Unread Count
// ============================================

/**
 * Update unread message count for a user in a thread
 */
async function updateUnreadCount(
  threadId: string,
  userId: string
): Promise<void> {
  try {
    const threadRef = db.collection("chat_threads").doc(threadId);

    // Use FieldValue.increment to atomically increment
    await threadRef.update({
      [`unreadCount.${userId}`]: admin.firestore.FieldValue.increment(1),
    });

    console.log(
      `Updated unread count for user ${userId} in thread ${threadId}`
    );
  } catch (error) {
    console.error("Error updating unread count:", error);
  }
}

// ============================================
// CALLABLE: Mark Thread as Read
// ============================================

/**
 * Mark all messages in a thread as read for current user
 *
 * Usage:
 * const markAsRead = firebase.functions().httpsCallable('markThreadAsRead');
 * await markAsRead({ threadId: 'xxx' });
 */
export const markThreadAsRead = functions.https.onCall(
  async (data, context) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const userId = context.auth.uid;
    const { threadId } = data;

    if (!threadId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "threadId is required"
      );
    }

    try {
      // Reset unread count for this user
      await db
        .collection("chat_threads")
        .doc(threadId)
        .update({
          [`unreadCount.${userId}`]: 0,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      console.log(`✅ Thread ${threadId} marked as read by user ${userId}`);

      return {
        success: true,
        message: "Thread marked as read",
      };
    } catch (error: any) {
      console.error("Error marking thread as read:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  }
);

// ============================================
// CALLABLE: Create or Get Chat Thread
// ============================================

/**
 * Create a new chat thread or get existing one between two users
 *
 * Usage:
 * const getThread = firebase.functions().httpsCallable('getOrCreateThread');
 * await getThread({ otherUserId: 'xxx', type: 'support' });
 */
export const getOrCreateThread = functions.https.onCall(
  async (data, context) => {
    // Verify authentication
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const userId = context.auth.uid;
    const { otherUserId, type = "support" } = data;

    if (!otherUserId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "otherUserId is required"
      );
    }

    try {
      // Check if thread already exists between these users
      const existingThreads = await db
        .collection("chat_threads")
        .where("participants", "array-contains", userId)
        .where("type", "==", type)
        .get();

      // Find thread with both participants
      const existingThread = existingThreads.docs.find((doc) => {
        const participants = doc.data().participants as string[];
        return participants.includes(otherUserId);
      });

      if (existingThread) {
        console.log(`Found existing thread: ${existingThread.id}`);
        return {
          success: true,
          threadId: existingThread.id,
          thread: existingThread.data(),
          isNew: false,
        };
      }

      // Create new thread
      const threadRef = db.collection("chat_threads").doc();

      const newThread = {
        id: threadRef.id,
        participants: [userId, otherUserId],
        type: type, // 'support', 'courier', 'admin'
        lastMessage: null,
        lastMessageAt: null,
        unreadCount: {
          [userId]: 0,
          [otherUserId]: 0,
        },
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      };

      await threadRef.set(newThread);

      console.log(`✅ Created new thread: ${threadRef.id}`);

      return {
        success: true,
        threadId: threadRef.id,
        thread: newThread,
        isNew: true,
      };
    } catch (error: any) {
      console.error("Error creating thread:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  }
);

// ============================================
// CALLABLE: Send Chat Message
// ============================================

/**
 * Send a chat message (alternative to direct Firestore write)
 * Useful for additional validation or processing
 *
 * Usage:
 * const sendMessage = firebase.functions().httpsCallable('sendChatMessage');
 * await sendMessage({ threadId: 'xxx', text: 'Hello', imageUrl: null });
 */
export const sendChatMessage = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be authenticated"
    );
  }

  const userId = context.auth.uid;
  const { threadId, text, imageUrl = null } = data;

  if (!threadId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "threadId is required"
    );
  }

  if (!text && !imageUrl) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Either text or imageUrl must be provided"
    );
  }

  try {
    // Verify user is participant
    const threadDoc = await db.collection("chat_threads").doc(threadId).get();

    if (!threadDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Thread not found");
    }

    const participants = threadDoc.data()!.participants as string[];
    if (!participants.includes(userId)) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "User is not a participant in this thread"
      );
    }

    // Create message
    const messageRef = db
      .collection("chat_threads")
      .doc(threadId)
      .collection("messages")
      .doc();

    const message = {
      id: messageRef.id,
      senderId: userId,
      text: text || null,
      imageUrl: imageUrl || null,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await messageRef.set(message);

    console.log(`✅ Message sent in thread ${threadId}`);

    return {
      success: true,
      messageId: messageRef.id,
      message,
    };
  } catch (error: any) {
    console.error("Error sending message:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

// ============================================
// CALLABLE: Delete Message
// ============================================

/**
 * Delete a chat message
 * Only sender can delete their own messages
 */
export const deleteChatMessage = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const userId = context.auth.uid;
    const { threadId, messageId } = data;

    if (!threadId || !messageId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "threadId and messageId are required"
      );
    }

    try {
      const messageRef = db
        .collection("chat_threads")
        .doc(threadId)
        .collection("messages")
        .doc(messageId);

      const messageDoc = await messageRef.get();

      if (!messageDoc.exists) {
        throw new functions.https.HttpsError("not-found", "Message not found");
      }

      const message = messageDoc.data()!;

      // Only sender can delete
      if (message.senderId !== userId) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Only sender can delete their own messages"
        );
      }

      await messageRef.delete();

      console.log(`✅ Message ${messageId} deleted from thread ${threadId}`);

      return {
        success: true,
        message: "Message deleted",
      };
    } catch (error: any) {
      console.error("Error deleting message:", error);
      throw new functions.https.HttpsError("internal", error.message);
    }
  }
);

// ============================================
// EXPORTS
// ============================================

export const chatFunctions = {
  onMessageWrite,
  markThreadAsRead,
  getOrCreateThread,
  sendChatMessage,
  deleteChatMessage,
};
