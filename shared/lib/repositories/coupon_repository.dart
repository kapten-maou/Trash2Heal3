import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/coupon_model.dart';
import '../services/firebase_service.dart';

/// Repository for managing user coupons/vouchers
/// Handles coupon creation, validation, and usage
class CouponRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('coupons');

  // ==================== CREATE ====================

  /// Create new coupon
  Future<String> createCoupon(CouponModel coupon) async {
    try {
      final data = coupon.toFirestore();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Coupon created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance
            .recordError(e, stack, reason: 'Failed to create coupon');
      }
      rethrow;
    }
  }

  /// Generate unique coupon code
  String generateCouponCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();

    // Format: T2H-XXXX-XXXX (T2H = TRASH2HEAL prefix)
    final part1 =
        List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
    final part2 =
        List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();

    return 'T2H-$part1-$part2';
  }

  /// Create coupon from redemption
  Future<String> createCouponFromRedemption({
    required String userId,
    required String redeemRequestId,
    required CouponType type,
    required String name,
    required int value,
    required int pointsSpent,
    String? provider,
    String? category,
    String? imageUrl,
    String? terms,
    String? instructions,
    DateTime? expiryDate,
  }) async {
    final code = generateCouponCode();

    final coupon = CouponModel(
      id: '',
      userId: userId,
      code: code,
      name: name,
      type: type,
      value: value,
      pointsSpent: pointsSpent,
      status: CouponStatus.active,
      redeemRequestId: redeemRequestId,
      provider: provider,
      category: category,
      imageUrl: imageUrl,
      terms: terms,
      instructions: instructions,
      expiryDate: expiryDate,
    );

    return await createCoupon(coupon);
  }

  // ==================== READ ====================

  /// Get coupon by ID
  Future<CouponModel?> getCouponById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return CouponModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get coupon by code
  Future<CouponModel?> getCouponByCode(String code) async {
    try {
      final snapshot =
          await _collection.where('code', isEqualTo: code).limit(1).get();

      if (snapshot.docs.isEmpty) return null;
      return CouponModel.fromFirestore(snapshot.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get all coupons for a user
  Future<List<CouponModel>> getUserCoupons(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CouponModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get active coupons for a user
  Future<List<CouponModel>> getActiveCoupons(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: CouponStatus.active.name)
          .orderBy('createdAt', descending: true)
          .get();

      final now = DateTime.now();
      return snapshot.docs
          .map((doc) => CouponModel.fromFirestore(doc))
          .where((coupon) {
        // Filter out expired coupons
        if (coupon.expiryDate != null && coupon.expiryDate!.isBefore(now)) {
          return false;
        }
        return true;
      }).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get coupons by status
  Future<List<CouponModel>> getCouponsByStatus(
    String userId,
    CouponStatus status,
  ) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CouponModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ==================== UPDATE ====================

  /// Update coupon
  Future<void> updateCoupon(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Coupon updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Mark coupon as used
  Future<void> useCoupon(
    String id, {
    String? usedLocation,
  }) async {
    try {
      await _collection.doc(id).update({
        'status': CouponStatus.used.name,
        'usedAt': FieldValue.serverTimestamp(),
        'usedLocation': usedLocation,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('Coupon used');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Mark expired coupons (batch operation)
  Future<void> markExpiredCoupons() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('status', isEqualTo: CouponStatus.active.name)
          .get();

      final batch = _firebase.firestore.batch();
      int count = 0;

      for (var doc in snapshot.docs) {
        final coupon = CouponModel.fromFirestore(doc);
        if (coupon.expiryDate != null && coupon.expiryDate!.isBefore(now)) {
          batch.update(doc.reference, {
            'status': CouponStatus.expired.name,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          count++;
        }
      }

      if (count > 0) {
        await batch.commit();
        _firebase.logEvent('Coupons expired');
      }
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Cancel coupon (refund scenario)
  Future<void> cancelCoupon(String id) async {
    try {
      await _collection.doc(id).update({
        'status': CouponStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('Coupon cancelled');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ==================== VALIDATION ====================

  /// Check if coupon is valid
  Future<bool> isValid(String id) async {
    try {
      final coupon = await getCouponById(id);
      if (coupon == null) return false;

      // Check status
      if (coupon.status != CouponStatus.active) return false;

      // Check expiry
      if (coupon.expiryDate != null &&
          coupon.expiryDate!.isBefore(DateTime.now())) {
        // Auto-mark as expired
        await updateCoupon(id, {'status': CouponStatus.expired.name});
        return false;
      }

      return true;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      return false;
    }
  }

  /// Validate coupon code
  Future<Map<String, dynamic>> validateCode(String code) async {
    try {
      final coupon = await getCouponByCode(code);

      if (coupon == null) {
        return {'valid': false, 'message': 'Kode voucher tidak ditemukan'};
      }

      if (coupon.status != CouponStatus.active) {
        return {
          'valid': false,
          'message': 'Voucher sudah ${_getStatusText(coupon.status)}'
        };
      }

      if (coupon.expiryDate != null &&
          coupon.expiryDate!.isBefore(DateTime.now())) {
        return {'valid': false, 'message': 'Voucher sudah kadaluarsa'};
      }

      return {
        'valid': true,
        'message': 'Voucher valid',
        'coupon': coupon,
      };
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      return {'valid': false, 'message': 'Terjadi kesalahan validasi'};
    }
  }

  String _getStatusText(CouponStatus status) {
    switch (status) {
      case CouponStatus.used:
        return 'digunakan';
      case CouponStatus.expired:
        return 'kadaluarsa';
      case CouponStatus.cancelled:
        return 'dibatalkan';
      default:
        return 'tidak aktif';
    }
  }

  // ==================== STREAMS ====================

  /// Watch user's active coupons
  Stream<List<CouponModel>> watchActiveCoupons(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: CouponStatus.active.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CouponModel.fromFirestore(doc))
            .toList());
  }

  /// Watch all user coupons
  Stream<List<CouponModel>> watchUserCoupons(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CouponModel.fromFirestore(doc))
            .toList());
  }

  // ==================== DELETE ====================

  /// Delete coupon (admin only)
  Future<void> deleteCoupon(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Coupon deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
