import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/pickup_slot_model.dart';
import '../services/firebase_service.dart';

class PickupSlotRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pickupSlots');

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createPickupSlot(PickupSlotModel slot) async {
    try {
      final data = slot.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Pickup slot created: ${docRef.id}');
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

  Future<PickupSlotModel?> getPickupSlotById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PickupSlotModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<PickupSlotModel>> getAvailableSlotsByDate(
    DateTime date,
    String zone,
  ) async {
    try {
      // Start and end of the selected date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      var queryRef = _collection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .where('isActive', isEqualTo: true);

      // Optional zone filter: if "all", skip filter
      if (zone.toLowerCase() != 'all') {
        queryRef = queryRef.where('zone', isEqualTo: zone);
      }

      final query = await queryRef.orderBy('date').get();

      return query.docs
          .map((doc) => PickupSlotModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<PickupSlotModel>> watchAvailableSlots(
    DateTime startDate,
    DateTime endDate,
    String zone,
  ) {
    return _collection
        .where('zone', isEqualTo: zone)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .where('isActive', isEqualTo: true)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupSlotModel.fromFirestore(doc))
            .toList());
  }

  Future<List<PickupSlotModel>> getSlotsByCourier(String courierId) async {
    try {
      final query = await _collection
          .where('assignedCourierId', isEqualTo: courierId)
          .where('isActive', isEqualTo: true)
          .orderBy('date')
          .get();

      return query.docs
          .map((doc) => PickupSlotModel.fromFirestore(doc))
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

  Future<void> updatePickupSlot(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Pickup slot updated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Reserve slot capacity when user books pickup
  Future<bool> reserveSlotCapacity(String slotId, double weightKg) async {
    try {
      return await _firebase.runTransaction<bool>((transaction) async {
        final slotRef = _collection.doc(slotId);
        final snapshot = await transaction.get(slotRef);

        if (!snapshot.exists) {
          throw Exception('Slot not found');
        }

        final slot = PickupSlotModel.fromFirestore(snapshot);

        // Check if slot has enough capacity
        final newUsedWeight = slot.usedWeightKg + weightKg;
        if (newUsedWeight > slot.capacityWeightKg) {
          return false; // Slot full
        }

        // Update used weight
        transaction.update(slotRef, {
          'usedWeightKg': newUsedWeight,
          'isFull': newUsedWeight >= slot.capacityWeightKg,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return true;
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Release slot capacity when pickup is cancelled
  Future<void> releaseSlotCapacity(String slotId, double weightKg) async {
    try {
      await _firebase.runTransaction((transaction) async {
        final slotRef = _collection.doc(slotId);
        final snapshot = await transaction.get(slotRef);

        if (!snapshot.exists) return;

        final slot = PickupSlotModel.fromFirestore(snapshot);
        final newUsedWeight =
            (slot.usedWeightKg - weightKg).clamp(0.0, slot.capacityWeightKg);

        transaction.update(slotRef, {
          'usedWeightKg': newUsedWeight,
          'isFull': false,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      _firebase.logEvent('Slot capacity released: $slotId');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> assignCourier(
      String slotId, String courierId, String courierName) async {
    try {
      await _collection.doc(slotId).update({
        'assignedCourierId': courierId,
        'assignedCourierName': courierName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Courier assigned to slot: $slotId');
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

  Future<void> deletePickupSlot(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Pickup slot deleted: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> deactivatePickupSlot(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Pickup slot deactivated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
