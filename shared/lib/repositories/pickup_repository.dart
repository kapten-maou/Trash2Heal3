import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/pickup_request_model.dart';
import '../services/firebase_service.dart';

class PickupRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pickupRequests');

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

  Future<void> updateStatus(String id, String status) async {
    try {
      final data = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add specific timestamp for certain statuses
      if (status == 'assigned') {
        data['assignedAt'] = FieldValue.serverTimestamp();
      } else if (status == 'on_the_way') {
        data['onTheWayAt'] = FieldValue.serverTimestamp();
      } else if (status == 'arrived') {
        data['arrivedAt'] = FieldValue.serverTimestamp();
      } else if (status == 'picked_up') {
        data['pickedUpAt'] = FieldValue.serverTimestamp();
      } else if (status == 'completed') {
        data['completedAt'] = FieldValue.serverTimestamp();
      } else if (status == 'cancelled') {
        data['cancelledAt'] = FieldValue.serverTimestamp();
      }

      await _collection.doc(id).update(data);
      _firebase.logEvent('pickup_status_updated');
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
      await _collection.doc(requestId).update({
        'actualWeightKg': actualWeightKg,
        'actualPoints': actualPoints,
        'proofPhotoUrls': proofPhotoUrls,
        'courierNotes': courierNotes,
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
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('pickup_cancelled');
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
}
