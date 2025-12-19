import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/firebase_service.dart';

class NotificationRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('notifications');

  // CREATE - Send notification
  Future<String> sendNotification(NotificationModel notification) async {
    try {
      final now = DateTime.now();
      final data = notification
          .copyWith(
            createdAt: now,
            isSent: true,
            sentAt: now,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      _firebase.logEvent('notification_sent');

      // TODO: Integrate with FCM to send push notification
      // await _sendPushNotification(notification);

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to send notification',
        );
      }
      rethrow;
    }
  }

  // CREATE - Batch send notifications
  Future<void> sendBatchNotifications(
    List<NotificationModel> notifications,
  ) async {
    try {
      final batch = _firebase.firestore.batch();
      final now = DateTime.now();

      for (final notification in notifications) {
        final data = notification
            .copyWith(
              createdAt: now,
              isSent: true,
              sentAt: now,
            )
            .toFirestore();

        final docRef = _collection.doc();
        batch.set(docRef, data);
      }

      await batch.commit();

      _firebase.logEvent('notifications_batch_sent');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to send batch notifications',
        );
      }
      rethrow;
    }
  }

  // READ - Get by ID
  Future<NotificationModel?> getNotificationById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return NotificationModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get notification by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get notifications by user
  Future<List<NotificationModel>> getNotificationsByUser(
    String userId, {
    int limit = 50,
  }) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get notifications by user: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get unread notifications
  Future<List<NotificationModel>> getUnreadNotifications(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get unread notifications: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .where('isDeleted', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get unread count: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get notifications by type
  Future<List<NotificationModel>> getNotificationsByType(
    String userId,
    NotificationType type,
  ) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.name)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get notifications by type: ${type.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get notifications by priority
  Future<List<NotificationModel>> getNotificationsByPriority(
    String userId,
    NotificationPriority priority,
  ) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('priority', isEqualTo: priority.name)
          .where('isDeleted', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get notifications by priority: ${priority.name}',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark as read
  Future<void> markAsRead(String id) async {
    try {
      await _collection.doc(id).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('notification_read');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark notification as read: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark all as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      _firebase.logEvent('notifications_marked_all_read');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark all notifications as read: $userId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark as delivered
  Future<void> markAsDelivered(String id, String? messageId) async {
    try {
      final updates = <String, dynamic>{
        'isDelivered': true,
        'deliveredAt': FieldValue.serverTimestamp(),
      };

      if (messageId != null) {
        updates['fcmMessageId'] = messageId;
      }

      await _collection.doc(id).update(updates);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark notification as delivered: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Mark as failed
  Future<void> markAsFailed(String id, String reason) async {
    try {
      await _collection.doc(id).update({
        'isFailed': true,
        'failureReason': reason,
      });

      _firebase.logEvent('notification_failed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to mark notification as failed: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE (Soft delete)
  Future<void> deleteNotification(String id) async {
    try {
      await _collection.doc(id).update({
        'isDeleted': true,
        'deletedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('notification_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete notification: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE - Delete all for user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final snapshot =
          await _collection.where('userId', isEqualTo: userId).get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'isDeleted': true,
          'deletedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      _firebase.logEvent('notifications_deleted_all');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete all notifications: $userId',
        );
      }
      rethrow;
    }
  }

  // BATCH - Clean old notifications (scheduled job)
  Future<int> cleanOldNotifications({int daysOld = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final snapshot = await _collection
          .where('createdAt', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      _firebase.logEvent('notifications_cleaned');

      return snapshot.docs.length;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to clean old notifications',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch notifications
  Stream<List<NotificationModel>> watchNotifications(
    String userId, {
    int limit = 50,
  }) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch unread count
  Stream<int> watchUnreadCount(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // STREAM - Watch unread notifications
  Stream<List<NotificationModel>> watchUnreadNotifications(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  // Convenience method aliases
  Future<List<NotificationModel>> getByUserId(String userId) =>
      getNotificationsByUser(userId);
  
  Future<void> update(NotificationModel notification) async {
    final data = notification.toFirestore();
    await _collection.doc(notification.id).update(data);
  }
  
  Future<void> delete(String id) => deleteNotification(id);
}