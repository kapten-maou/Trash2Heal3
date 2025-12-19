import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/chat_thread_model.dart';
import '../models/chat_message_model.dart';
import '../services/firebase_service.dart';

class ChatRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _threadsCollection =>
      _firebase.firestore.collection('chatThreads');

  CollectionReference get _messagesCollection =>
      _firebase.firestore.collection('chatMessages');

  // ============================================
  // THREAD OPERATIONS
  // ============================================

  // CREATE - Create or get thread
  Future<String> createOrGetThread(ChatThreadModel thread) async {
    try {
      // Check if thread already exists
      final existingThread = await _getThreadByParticipants(
        thread.participantIds,
      );

      if (existingThread != null) {
        return existingThread.id;
      }

      // Create new thread
      final now = DateTime.now();
      final data = thread
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef = await _threadsCollection.add(data);

      _firebase.logEvent('chat_thread_created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to create thread',
        );
      }
      rethrow;
    }
  }

  // READ - Get thread by ID
  Future<ChatThreadModel?> getThreadById(String id) async {
    try {
      final doc = await _threadsCollection.doc(id).get();
      if (!doc.exists) return null;
      return ChatThreadModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get thread by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get thread by participants
  Future<ChatThreadModel?> _getThreadByParticipants(
    List<String> participantIds,
  ) async {
    try {
      final snapshot = await _threadsCollection
          .where('participantIds', isEqualTo: participantIds)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return ChatThreadModel.fromFirestore(snapshot.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get thread by participants',
        );
      }
      rethrow;
    }
  }

  // READ - Get threads by user
  Future<List<ChatThreadModel>> getThreadsByUser(String userId) async {
    try {
      final snapshot = await _threadsCollection
          .where('participantIds', arrayContains: userId)
          .where('status', isEqualTo: 'active')
          .orderBy('lastMessageAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ChatThreadModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get threads by user: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get threads by type
  Future<List<ChatThreadModel>> getThreadsByType(
    String userId,
    ThreadType type,
  ) async {
    try {
      final snapshot = await _threadsCollection
          .where('participantIds', arrayContains: userId)
          .where('type', isEqualTo: type.name)
          .where('status', isEqualTo: 'active')
          .orderBy('lastMessageAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ChatThreadModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get threads by type: ${type.name}',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Update thread
  Future<void> updateThread(String id, Map<String, dynamic> updates) async {
    try {
      await _threadsCollection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update thread: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Reset unread count
  Future<void> resetUnreadCount(String threadId, String userId) async {
    try {
      await _threadsCollection.doc(threadId).update({
        'unreadCount.$userId': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to reset unread count: $threadId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Toggle pin
  Future<void> togglePin(String threadId, bool isPinned) async {
    try {
      await _threadsCollection.doc(threadId).update({
        'isPinned': isPinned,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to toggle pin: $threadId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Toggle mute
  Future<void> toggleMute(String threadId, String userId, bool isMuted) async {
    try {
      final thread = await getThreadById(threadId);
      if (thread == null) return;

      List<String> mutedBy = List<String>.from(thread.mutedBy ?? []);

      if (isMuted) {
        if (!mutedBy.contains(userId)) {
          mutedBy.add(userId);
        }
      } else {
        mutedBy.remove(userId);
      }

      await _threadsCollection.doc(threadId).update({
        'isMuted': mutedBy.isNotEmpty,
        'mutedBy': mutedBy,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to toggle mute: $threadId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Close thread
  Future<void> closeThread(
      String threadId, String closedBy, String reason) async {
    try {
      await _threadsCollection.doc(threadId).update({
        'status': 'closed',
        'closedBy': closedBy,
        'closedReason': reason,
        'closedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('chat_thread_closed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to close thread: $threadId',
        );
      }
      rethrow;
    }
  }

  // ============================================
  // MESSAGE OPERATIONS
  // ============================================

  // CREATE - Send message
  Future<String> sendMessage(ChatMessageModel message) async {
    try {
      final now = DateTime.now();
      final data = message
          .copyWith(
            status: MessageStatus.sent,
            createdAt: now,
          )
          .toFirestore();

      final docRef = await _messagesCollection.add(data);

      // Update thread with last message info
      await _updateThreadLastMessage(
        message.threadId,
        message.message,
        message.senderId,
        message.senderName,
      );

      // Increment unread count for other participants
      await _incrementUnreadCount(message.threadId, message.senderId);

      _firebase.logEvent('chat_message_sent');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to send message',
        );
      }
      rethrow;
    }
  }

  // READ - Get message by ID
  Future<ChatMessageModel?> getMessageById(String id) async {
    try {
      final doc = await _messagesCollection.doc(id).get();
      if (!doc.exists) return null;
      return ChatMessageModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get message by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get messages by thread
  Future<List<ChatMessageModel>> getMessagesByThread(
    String threadId, {
    int limit = 50,
  }) async {
    try {
      final snapshot = await _messagesCollection
          .where('threadId', isEqualTo: threadId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get messages by thread: $threadId',
        );
      }
      rethrow;
    }
  }

  // READ - Get messages after timestamp
  Future<List<ChatMessageModel>> getMessagesAfter(
    String threadId,
    DateTime after,
  ) async {
    try {
      final snapshot = await _messagesCollection
          .where('threadId', isEqualTo: threadId)
          .where('createdAt', isGreaterThan: Timestamp.fromDate(after))
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt')
          .get();

      return snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get messages after timestamp',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark message as read
  Future<void> markMessageAsRead(
    String messageId,
    String userId,
    String userName,
  ) async {
    try {
      await _messagesCollection.doc(messageId).update({
        'status': 'read',
        'readAt': FieldValue.serverTimestamp(),
        'readBy.$userId': {
          'name': userName,
          'readAt': FieldValue.serverTimestamp(),
        },
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark message as read: $messageId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark all messages as read
  Future<void> markAllMessagesAsRead(
    String threadId,
    String userId,
    String userName,
  ) async {
    try {
      final snapshot = await _messagesCollection
          .where('threadId', isEqualTo: threadId)
          .where('status', whereIn: ['sent', 'delivered']).get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        final message = ChatMessageModel.fromFirestore(doc);
        if (message.senderId != userId) {
          batch.update(doc.reference, {
            'status': 'read',
            'readAt': FieldValue.serverTimestamp(),
            'readBy.$userId': {
              'name': userName,
              'readAt': FieldValue.serverTimestamp(),
            },
          });
        }
      }

      await batch.commit();

      // Reset unread count
      await resetUnreadCount(threadId, userId);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark all messages as read',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Edit message
  Future<void> editMessage(String messageId, String newMessage) async {
    try {
      await _messagesCollection.doc(messageId).update({
        'message': newMessage,
        'isEdited': true,
        'editedMessage': newMessage,
        'editedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('chat_message_edited');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to edit message: $messageId',
        );
      }
      rethrow;
    }
  }

  // DELETE - Delete message (soft delete)
  Future<void> deleteMessage(String messageId, String deletedBy) async {
    try {
      await _messagesCollection.doc(messageId).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
        'deletedBy': deletedBy,
      });

      _firebase.logEvent('chat_message_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete message: $messageId',
        );
      }
      rethrow;
    }
  }

  // ============================================
  // HELPER METHODS
  // ============================================

  Future<void> _updateThreadLastMessage(
    String threadId,
    String message,
    String senderId,
    String senderName,
  ) async {
    await _threadsCollection.doc(threadId).update({
      'lastMessage': message,
      'lastMessageSenderId': senderId,
      'lastMessageSenderName': senderName,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _incrementUnreadCount(String threadId, String senderId) async {
    final thread = await getThreadById(threadId);
    if (thread == null) return;

    final updates = <String, dynamic>{};
    for (final participantId in thread.participantIds) {
      if (participantId != senderId) {
        updates['unreadCount.$participantId'] = FieldValue.increment(1);
      }
    }

    if (updates.isNotEmpty) {
      await _threadsCollection.doc(threadId).update(updates);
    }
  }

  // ============================================
  // STREAMS
  // ============================================

  // STREAM - Watch thread
  Stream<ChatThreadModel?> watchThread(String threadId) {
    return _threadsCollection.doc(threadId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ChatThreadModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch threads by user
  Stream<List<ChatThreadModel>> watchThreadsByUser(String userId) {
    return _threadsCollection
        .where('participantIds', arrayContains: userId)
        .where('status', isEqualTo: 'active')
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatThreadModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch messages by thread
  Stream<List<ChatMessageModel>> watchMessagesByThread(
    String threadId, {
    int limit = 50,
  }) {
    return _messagesCollection
        .where('threadId', isEqualTo: threadId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch new messages (for real-time updates)
  Stream<ChatMessageModel> watchNewMessages(String threadId) {
    return _messagesCollection
        .where('threadId', isEqualTo: threadId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        throw Exception('No messages');
      }
      return ChatMessageModel.fromFirestore(snapshot.docs.first);
    });
  }

  // Convenience method aliases
  Future<List<ChatThreadModel>> getUserThreads(String userId) =>
      getThreadsByUser(userId);

  Future<List<ChatMessageModel>> getThreadMessages(
    String threadId, {
    int limit = 50,
  }) =>
      getMessagesByThread(threadId, limit: limit);

  Future<String> createThread(ChatThreadModel thread) =>
      createOrGetThread(thread);
}
