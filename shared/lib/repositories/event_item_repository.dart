import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event_item_model.dart';
import '../services/firebase_service.dart';

class EventItemRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('eventItems');

  // CREATE
  Future<String> createEventItem(EventItemModel item) async {
    try {
      final now = DateTime.now();
      final data = item
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      _firebase.logEvent('event_item_created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to create event item',
        );
      }
      rethrow;
    }
  }

  // READ - Get by ID
  Future<EventItemModel?> getEventItemById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return EventItemModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get event item by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get items by event
  Future<List<EventItemModel>> getItemsByEvent(String eventId) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder')
          .orderBy('pointsRequired')
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get items by event: $eventId',
        );
      }
      rethrow;
    }
  }

  // READ - Get available items by event
  Future<List<EventItemModel>> getAvailableItemsByEvent(String eventId) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: 'available')
          .orderBy('displayOrder')
          .orderBy('pointsRequired')
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .where((item) => item.stock > item.claimed + item.reserved)
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get available items by event: $eventId',
        );
      }
      rethrow;
    }
  }

  // READ - Get items by type
  Future<List<EventItemModel>> getItemsByType(
    String eventId,
    EventItemType type,
  ) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .where('type', isEqualTo: type.name)
          .where('isActive', isEqualTo: true)
          .orderBy('pointsRequired')
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get items by type: ${type.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get featured items
  Future<List<EventItemModel>> getFeaturedItems(String eventId) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .where('isFeatured', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder')
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get featured items: $eventId',
        );
      }
      rethrow;
    }
  }

  // READ - Get items by points range
  Future<List<EventItemModel>> getItemsByPointsRange(
    String eventId,
    int minPoints,
    int maxPoints,
  ) async {
    try {
      final snapshot = await _collection
          .where('eventId', isEqualTo: eventId)
          .where('pointsRequired', isGreaterThanOrEqualTo: minPoints)
          .where('pointsRequired', isLessThanOrEqualTo: maxPoints)
          .where('isActive', isEqualTo: true)
          .orderBy('pointsRequired')
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get items by points range',
        );
      }
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateEventItem(String id, Map<String, dynamic> updates) async {
    try {
      await _collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_item_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update event item: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Increment claimed count (with transaction)
  Future<bool> incrementClaimedCount(String id) async {
    try {
      final result =
          await _firebase.firestore.runTransaction((transaction) async {
        final docRef = _collection.doc(id);
        final doc = await transaction.get(docRef);

        if (!doc.exists) {
          throw Exception('Item not found');
        }

        final item = EventItemModel.fromFirestore(doc);

        // Check if still available
        if (item.claimed + item.reserved >= item.stock) {
          return false; // Out of stock
        }

        // Increment claimed count
        transaction.update(docRef, {
          'claimed': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update status if needed
        final newClaimed = item.claimed + 1;
        if (newClaimed >= item.stock) {
          transaction.update(docRef, {
            'status': 'out_of_stock',
          });
        } else if (newClaimed >= item.stock * 0.8) {
          transaction.update(docRef, {
            'status': 'low_stock',
          });
        }

        return true;
      });

      if (result) {
        _firebase.logEvent('event_item_claimed');
      }

      return result;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to increment claimed count: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Reserve item (with transaction)
  Future<bool> reserveItem(String id, int quantity) async {
    try {
      final result =
          await _firebase.firestore.runTransaction((transaction) async {
        final docRef = _collection.doc(id);
        final doc = await transaction.get(docRef);

        if (!doc.exists) {
          throw Exception('Item not found');
        }

        final item = EventItemModel.fromFirestore(doc);

        // Check if enough stock
        if (item.claimed + item.reserved + quantity > item.stock) {
          return false;
        }

        transaction.update(docRef, {
          'reserved': FieldValue.increment(quantity),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return true;
      });

      return result;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to reserve item: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Release reservation
  Future<void> releaseReservation(String id, int quantity) async {
    try {
      await _collection.doc(id).update({
        'reserved': FieldValue.increment(-quantity),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to release reservation: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Change status
  Future<void> changeItemStatus(String id, EventItemStatus status) async {
    try {
      await _collection.doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_item_status_changed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to change item status: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE (Soft delete)
  Future<void> deactivateEventItem(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'status': 'discontinued',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_item_deactivated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to deactivate event item: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE (Hard delete - admin only)
  Future<void> deleteEventItem(String id) async {
    try {
      await _collection.doc(id).delete();

      _firebase.logEvent('event_item_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete event item: $id',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch item
  Stream<EventItemModel?> watchEventItem(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EventItemModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch items by event
  Stream<List<EventItemModel>> watchItemsByEvent(String eventId) {
    return _collection
        .where('eventId', isEqualTo: eventId)
        .where('isActive', isEqualTo: true)
        .orderBy('displayOrder')
        .orderBy('pointsRequired')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventItemModel.fromFirestore(doc))
            .toList());
  }

  // STREAM - Watch available items
  Stream<List<EventItemModel>> watchAvailableItems(String eventId) {
    return _collection
        .where('eventId', isEqualTo: eventId)
        .where('isActive', isEqualTo: true)
        .where('status', isEqualTo: 'available')
        .orderBy('displayOrder')
        .orderBy('pointsRequired')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => EventItemModel.fromFirestore(doc))
            .where((item) => item.stock > item.claimed + item.reserved)
            .toList());
  }


  // ============================================================================
  // ADMIN WEB: GET ALL EVENT ITEMS
  // ============================================================================

  Future<List<EventItemModel>> getAll() async {
    try {
      final snapshot = await _collection
          .orderBy('createdAt', descending: true) // pastikan field ini ada
          .get();

      return snapshot.docs
          .map((doc) => EventItemModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get all event items',
        );
      }
      rethrow;
    }
  }





  

  // Convenience method aliases
  Future<List<EventItemModel>> getByEventId(String eventId) =>
      getItemsByEvent(eventId);
}
