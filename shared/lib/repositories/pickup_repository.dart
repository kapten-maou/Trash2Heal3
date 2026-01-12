import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/pickup_request_model.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';
import '../services/firebase_service.dart';

class PickupRepository {
  final FirebaseService _firebase = FirebaseService();
  final NotificationRepository _notificationRepo = NotificationRepository();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pickupRequests');

  // Canonical status strings (as stored in Firestore)
  static const Map<String, String> _statusMap = {
    'pending': 'pending',
    'assigned': 'assigned',
    'on_the_way': 'on_the_way',
    'ontheway': 'on_the_way',
    'onTheWay': 'on_the_way',
    'arrived': 'arrived',
    'picked_up': 'picked_up',
    'pickedup': 'picked_up',
    'pickedUp': 'picked_up',
    'completed': 'completed',
    'cancelled': 'cancelled',
    'canceled': 'cancelled',
  };

  String _canonicalStatus(String raw) {
    final key = raw.replaceAll(' ', '').trim();
    final value = _statusMap[key];
    if (value == null) {
      throw ArgumentError('Unsupported pickup status: $raw');
    }
    return value;
  }

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createPickupRequest(PickupRequestModel request) async {
    try {
      final data = request.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('pickup_request_created');
      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ============================================================================
  // READ
  // ============================================================================

  Future<PickupRequestModel?> getPickupRequestById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PickupRequestModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<PickupRequestModel?> watchPickupRequest(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return PickupRequestModel.fromFirestore(doc);
    });
  }

  Future<List<PickupRequestModel>> getPickupRequestsByUser(
    String userId, {
    String? status,
    int? limit,
  }) async {
    try {
      Query query = _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PickupRequestModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<PickupRequestModel>> watchUserPickupRequests(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRequestModel.fromFirestore(doc))
            .toList());
  }

  Future<List<PickupRequestModel>> getPendingRequests() async {
    try {
      final query = await _collection
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt')
          .get();

      return query.docs
          .map((doc) => PickupRequestModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ============================================================================
  // UPDATE
  // ============================================================================

  Future<void> updatePickupRequest(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('pickup_request_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> updateStatus(
    String id,
    String status, {
    String? userId,
    bool notify = true,
  }) async {
    try {
      final canonical = _canonicalStatus(status);
      String? targetUserId = userId;

      // Fetch userId if not provided
      if (targetUserId == null) {
        final doc = await _collection.doc(id).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          targetUserId = data['userId']?.toString();
        }
      }

      final data = {
        'status': canonical,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add specific timestamp for certain statuses
      if (canonical == 'assigned') {
        data['assignedAt'] = FieldValue.serverTimestamp();
      } else if (canonical == 'on_the_way') {
        data['onTheWayAt'] = FieldValue.serverTimestamp();
      } else if (canonical == 'arrived') {
        data['arrivedAt'] = FieldValue.serverTimestamp();
      } else if (canonical == 'picked_up') {
        data['pickedUpAt'] = FieldValue.serverTimestamp();
      } else if (canonical == 'completed') {
        data['completedAt'] = FieldValue.serverTimestamp();
      } else if (canonical == 'cancelled') {
        data['cancelledAt'] = FieldValue.serverTimestamp();
      }

      await _collection.doc(id).update(data);
      _firebase.logEvent('pickup_status_updated');

      // Fire notification if requested and userId known
      if (notify && targetUserId != null) {
        final template = _notificationForStatus(
          status: canonical,
          userId: targetUserId!,
          pickupId: id,
        );
        if (template != null) {
          await _notificationRepo.sendNotification(template);
        }
      }
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> assignCourier(
    String requestId,
    String courierId,
    String courierName,
    String courierPhone,
  ) async {
    try {
      // Generate 4-digit OTP
      final otp = _generateOtp();

      await _collection.doc(requestId).update({
        'courierId': courierId,
        'courierName': courierName,
        'courierPhone': courierPhone,
        'status': 'assigned',
        'otp': otp,
        'assignedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('courier_assigned');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> completePickup({
    required String requestId,
    required double actualWeightKg,
    required int actualPoints,
    required List<String> proofPhotoUrls,
    String? courierNotes,
  }) async {
    try {
      // Write both legacy and canonical field names to avoid drift.
      await _collection.doc(requestId).update({
        'actualWeight': actualWeightKg,
        'actualWeightKg': actualWeightKg,
        'actualPoints': actualPoints,
        'proofPhotos': proofPhotoUrls,
        'proofPhotoUrls': proofPhotoUrls,
        'notes': courierNotes,
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('pickup_completed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> cancelPickup(String id, String reason) async {
    try {
      await _collection.doc(id).update({
        'status': 'cancelled',
        // Align naming with model field while keeping legacy compatibility
        'cancelReason': reason,
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('pickup_cancelled');

      // Notify user about cancellation
      final doc = await _collection.doc(id).get();
      final data = doc.data() as Map<String, dynamic>?;
      final uid = data?['userId']?.toString();
      if (uid != null) {
        final notif = NotificationModel(
          id: '',
          userId: uid,
          title: 'Pickup dibatalkan',
          body: reason.isNotEmpty
              ? 'Alasan: $reason'
              : 'Pickup #$id telah dibatalkan.',
          type: NotificationType.pickupCancelled,
          priority: NotificationPriority.high,
          relatedId: id,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$id',
          createdAt: DateTime.now(),
        );
        await _notificationRepo.sendNotification(notif);
      }
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Verify OTP for pickup completion
  Future<bool> verifyOtp(String requestId, String otp) async {
    try {
      final request = await getPickupRequestById(requestId);
      if (request == null) return false;
      return request.otp == otp;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      return false;
    }
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  Future<void> deletePickupRequest(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('pickup_request_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Generate 4-digit OTP
  String _generateOtp() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  // Convenience method aliases
  Future<List<PickupRequestModel>> getByUserId(String userId) =>
      getPickupRequestsByUser(userId);

  Future<void> update(String id, String status) => updateStatus(id, status);

  NotificationModel? _notificationForStatus({
    required String status,
    required String userId,
    required String pickupId,
  }) {
    switch (status) {
      case 'assigned':
        return NotificationModel(
          id: '',
          userId: userId,
          title: 'Pickup ditugaskan',
          body: 'Kurir telah ditugaskan untuk pickup #$pickupId.',
          type: NotificationType.pickupAssigned,
          priority: NotificationPriority.high,
          relatedId: pickupId,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$pickupId',
          createdAt: DateTime.now(),
        );
      case 'arrived':
        return NotificationModel(
          id: '',
          userId: userId,
          title: 'Kurir sudah tiba',
          body: 'Kurir telah sampai di lokasi untuk pickup #$pickupId.',
          type: NotificationType.pickupOnTheWay,
          priority: NotificationPriority.high,
          relatedId: pickupId,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$pickupId',
          createdAt: DateTime.now(),
        );
      case 'picked_up':
        return NotificationModel(
          id: '',
          userId: userId,
          title: 'Pickup sedang diproses',
          body:
              'Sampah untuk pickup #$pickupId sudah diambil. Menunggu penimbangan.',
          type: NotificationType.pickupOnTheWay,
          priority: NotificationPriority.high,
          relatedId: pickupId,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$pickupId',
          createdAt: DateTime.now(),
        );
      case 'on_the_way':
        return NotificationModel(
          id: '',
          userId: userId,
          title: 'Kurir dalam perjalanan',
          body: 'Kurir menuju lokasi untuk pickup #$pickupId.',
          type: NotificationType.pickupOnTheWay,
          priority: NotificationPriority.high,
          relatedId: pickupId,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$pickupId',
          createdAt: DateTime.now(),
        );
      case 'completed':
        return NotificationModel(
          id: '',
          userId: userId,
          title: 'Pickup selesai',
          body: 'Pickup #$pickupId telah selesai. Cek riwayat dan poin Anda.',
          type: NotificationType.pickupCompleted,
          priority: NotificationPriority.high,
          relatedId: pickupId,
          relatedCollection: 'pickupRequests',
          actionRoute: '/history/$pickupId',
          createdAt: DateTime.now(),
        );
      default:
        return null;
    }
  }
}
