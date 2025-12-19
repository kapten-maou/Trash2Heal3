import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/pickup_rate_model.dart';
import '../services/firebase_service.dart';

class PickupRateRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pickupRates');

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createPickupRate(PickupRateModel rate) async {
    try {
      final data = rate.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Pickup rate created: ${docRef.id}');
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

  Future<PickupRateModel?> getPickupRateById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PickupRateModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<PickupRateModel>> getAllActiveRates() async {
    try {
      final query = await _collection
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return query.docs
          .map((doc) => PickupRateModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<PickupRateModel>> watchActiveRates() {
    return _collection
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupRateModel.fromFirestore(doc))
            .toList());
  }

  Future<PickupRateModel?> getRateByCategory(String category) async {
    try {
      final query = await _collection
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return PickupRateModel.fromFirestore(query.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Calculate estimated points based on quantities
  Future<int> calculateEstimatedPoints(Map<String, int> quantities) async {
    try {
      final rates = await getAllActiveRates();
      int totalPoints = 0;

      for (final entry in quantities.entries) {
        final category = entry.key;
        final quantity = entry.value;

        final rate = rates.firstWhere(
          (r) => r.category == category,
          orElse: () =>
              throw Exception('Rate not found for category: $category'),
        );

        // Calculate weight: quantity × avgWeightPerUnit
        final weightKg = quantity * rate.avgWeightPerUnit;

        // Calculate points: weight × pointsPerKg
        final points = (weightKg * rate.pointsPerKg).round();

        totalPoints += points;
      }

      return totalPoints;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Calculate estimated weight based on quantities
  Future<double> calculateEstimatedWeight(Map<String, int> quantities) async {
    try {
      final rates = await getAllActiveRates();
      double totalWeight = 0.0;

      for (final entry in quantities.entries) {
        final category = entry.key;
        final quantity = entry.value;

        final rate = rates.firstWhere(
          (r) => r.category == category,
          orElse: () =>
              throw Exception('Rate not found for category: $category'),
        );

        totalWeight += quantity * rate.avgWeightPerUnit;
      }

      return totalWeight;
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

  Future<void> updatePickupRate(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Pickup rate updated: $id');
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

  Future<void> deletePickupRate(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Pickup rate deleted: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> deactivatePickupRate(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Pickup rate deactivated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
