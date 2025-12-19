import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/payment_method_model.dart';
import '../services/firebase_service.dart';

class PaymentMethodRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection => _firebase.paymentMethods;

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createPaymentMethod(PaymentMethodModel method) async {
    try {
      final data = method.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Payment method created: ${docRef.id}');
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

  Future<PaymentMethodModel?> getPaymentMethodById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PaymentMethodModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<PaymentMethodModel>> getPaymentMethodsByUserId(
    String userId,
  ) async {
    try {
      final query = await _collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('isPrimary', descending: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => PaymentMethodModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<PaymentMethodModel>> watchUserPaymentMethods(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('isPrimary', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PaymentMethodModel.fromFirestore(doc))
            .toList());
  }

  Future<PaymentMethodModel?> getPrimaryPaymentMethod(String userId) async {
    try {
      final query = await _collection
          .where('userId', isEqualTo: userId)
          .where('isPrimary', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return PaymentMethodModel.fromFirestore(query.docs.first);
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

  Future<void> updatePaymentMethod(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Payment method updated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> setPrimaryPaymentMethod(String userId, String methodId) async {
    try {
      final batch = _firebase.batch();

      // Unset all other methods as non-primary
      final methods = await getPaymentMethodsByUserId(userId);
      for (final method in methods) {
        batch.update(_collection.doc(method.id), {'isPrimary': false});
      }

      // Set selected method as primary
      batch.update(_collection.doc(methodId), {
        'isPrimary': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      _firebase.logEvent('Primary payment method set: $methodId');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  Future<void> deletePaymentMethod(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Payment method deleted: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> deactivatePaymentMethod(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Payment method deactivated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
