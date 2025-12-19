import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/pickup_task_model.dart';
import '../services/firebase_service.dart';

class PickupTaskRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pickupTasks');

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createPickupTask(PickupTaskModel task) async {
    try {
      final data = task.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Pickup task created: ${docRef.id}');
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

  Future<PickupTaskModel?> getPickupTaskById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PickupTaskModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<PickupTaskModel?> getTaskByRequestId(String requestId) async {
    try {
      final query = await _collection
          .where('requestId', isEqualTo: requestId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return PickupTaskModel.fromFirestore(query.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<PickupTaskModel>> getTasksByCourier(
    String courierId, {
    String? status,
    DateTime? date,
  }) async {
    try {
      Query query = _collection.where('courierId', isEqualTo: courierId);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      if (date != null) {
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

        query = query
            .where('scheduledDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('scheduledDate',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
      }

      query = query.orderBy('scheduledDate');

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PickupTaskModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<PickupTaskModel>> watchCourierTasks(
    String courierId,
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _collection
        .where('courierId', isEqualTo: courierId)
        .where('scheduledDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('scheduledDate',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('scheduledDate')
        .orderBy('sequenceNumber')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PickupTaskModel.fromFirestore(doc))
            .toList());
  }

  Future<List<PickupTaskModel>> getTodayTasks(String courierId) async {
    final today = DateTime.now();
    return await getTasksByCourier(courierId, date: today);
  }

  Future<List<PickupTaskModel>> getUpcomingTasks(String courierId) async {
    try {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final startOfTomorrow =
          DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

      final query = await _collection
          .where('courierId', isEqualTo: courierId)
          .where('scheduledDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfTomorrow))
          .orderBy('scheduledDate')
          .get();

      return query.docs
          .map((doc) => PickupTaskModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<PickupTaskModel>> getCompletedTasks(
    String courierId, {
    int limit = 20,
  }) async {
    try {
      final query = await _collection
          .where('courierId', isEqualTo: courierId)
          .where('status', isEqualTo: 'completed')
          .orderBy('completedAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => PickupTaskModel.fromFirestore(doc))
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

  Future<void> updatePickupTask(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Pickup task updated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    try {
      final data = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (status == 'completed') {
        data['completedAt'] = FieldValue.serverTimestamp();
      }

      await _collection.doc(id).update(data);
      _firebase.logEvent('Task status updated: $id -> $status');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> setTaskSequence(String id, int sequenceNumber) async {
    try {
      await _collection.doc(id).update({
        'sequenceNumber': sequenceNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> setPriority(String id, bool isPriority) async {
    try {
      await _collection.doc(id).update({
        'isPriority': isPriority,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Task priority updated: $id');
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

  Future<void> deletePickupTask(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Pickup task deleted: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
