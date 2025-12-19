import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/redeem_request_model.dart';
import '../services/firebase_service.dart';

/// Repository for managing point redemption requests
/// Handles the full redemption workflow from request to approval
class RedeemRequestRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('redeemRequests');

  // ==================== CREATE ====================

  /// Create new redemption request
  Future<String> createRedeemRequest(RedeemRequestModel request) async {
    try {
      final data = request.toFirestore();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent(
          'Redeem request created - request_id: ${docRef.id}, user_id: ${request.userId}, type: ${request.type}, points: ${request.points}, amount: ${request.amount}');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance
            .recordError(e, stack, reason: 'Failed to create redeem request');
      }
      rethrow;
    }
  }

  /// Create voucher redemption request
  Future<String> createVoucherRedemption({
    required String userId,
    required String userName,
    required String userEmail,
    required String userPhone,
    required int points,
    required String voucherName,
    required String voucherProvider,
    required String voucherCategory,
    required int voucherValue,
    Map<String, dynamic>? metadata,
  }) async {
    final request = RedeemRequestModel(
      id: '',
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      type: 'voucher',
      points: points,
      amount: voucherValue,
      status: RedeemStatus.pending,
      voucherName: voucherName,
      voucherProvider: voucherProvider,
      voucherCategory: voucherCategory,
      voucherValue: voucherValue,
      metadata: metadata,
    );

    return await createRedeemRequest(request);
  }

  /// Create balance redemption request
  Future<String> createBalanceRedemption({
    required String userId,
    required String userName,
    required String userEmail,
    required String userPhone,
    required int points,
    required int amount,
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    Map<String, dynamic>? metadata,
  }) async {
    final request = RedeemRequestModel(
      id: '',
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      type: 'balance',
      points: points,
      amount: amount,
      status: RedeemStatus.pending,
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      metadata: metadata,
    );

    return await createRedeemRequest(request);
  }

  // ==================== READ ====================

  /// Get request by ID
  Future<RedeemRequestModel?> getRequestById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return RedeemRequestModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get all requests by user
  Future<List<RedeemRequestModel>> getUserRequests(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => RedeemRequestModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get requests by status
  Future<List<RedeemRequestModel>> getRequestsByStatus(
    RedeemStatus status,
  ) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt',
              descending: false) // Oldest first for processing
          .get();

      return snapshot.docs
          .map((doc) => RedeemRequestModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get pending requests (for admin)
  Future<List<RedeemRequestModel>> getPendingRequests() async {
    return await getRequestsByStatus(RedeemStatus.pending);
  }

  /// Get processing requests (for admin)
  Future<List<RedeemRequestModel>> getProcessingRequests() async {
    return await getRequestsByStatus(RedeemStatus.processing);
  }

  // ==================== UPDATE ====================

  /// Update request
  Future<void> updateRequest(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Redeem request updated - request_id: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Update status
  Future<void> updateStatus(String id, RedeemStatus status) async {
    try {
      await updateRequest(id, {'status': status.name});
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Start processing request (admin picks it up)
  Future<void> startProcessing(String id, String adminId) async {
    try {
      await _collection.doc(id).update({
        'status': RedeemStatus.processing.name,
        'processedBy': adminId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent(
          'Redeem processing started - request_id: $id, admin_id: $adminId');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Approve request (create coupon)
  Future<void> approveRequest({
    required String id,
    required String couponId,
    String? adminNotes,
    String? processedBy,
  }) async {
    try {
      await _collection.doc(id).update({
        'status': RedeemStatus.approved.name,
        'couponId': couponId,
        'adminNotes': adminNotes,
        'processedBy': processedBy,
        'processedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent(
          'Redeem request approved - request_id: $id, coupon_id: $couponId');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Reject request
  Future<void> rejectRequest({
    required String id,
    required String reason,
    String? adminNotes,
    String? processedBy,
  }) async {
    try {
      await _collection.doc(id).update({
        'status': RedeemStatus.rejected.name,
        'rejectionReason': reason,
        'adminNotes': adminNotes,
        'processedBy': processedBy,
        'processedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent(
          'Redeem request rejected - request_id: $id, reason: $reason');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Cancel request (by user)
  Future<void> cancelRequest(String id) async {
    try {
      await _collection.doc(id).update({
        'status': RedeemStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('Redeem request cancelled - request_id: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ==================== STREAMS ====================

  /// Watch user's requests
  Stream<List<RedeemRequestModel>> watchUserRequests(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RedeemRequestModel.fromFirestore(doc))
            .toList());
  }

  /// Watch pending requests (admin view)
  Stream<List<RedeemRequestModel>> watchPendingRequests() {
    return _collection
        .where('status', isEqualTo: RedeemStatus.pending.name)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RedeemRequestModel.fromFirestore(doc))
            .toList());
  }

  /// Watch single request
  Stream<RedeemRequestModel?> watchRequest(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return RedeemRequestModel.fromFirestore(doc);
    });
  }

  // ==================== ANALYTICS ====================

  /// Get total redemption value by user
  Future<int> getTotalRedemptionValue(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: RedeemStatus.approved.name)
          .get();

      int total = 0;
      for (var doc in snapshot.docs) {
        final request = RedeemRequestModel.fromFirestore(doc);
        total += request.amount;
      }
      return total;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get pending request count
  Future<int> getPendingCount() async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: RedeemStatus.pending.name)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      return 0;
    }
  }

  // ==================== DELETE ====================

  /// Delete request (admin only - use with caution)
  Future<void> deleteRequest(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Redeem request deleted - request_id: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
