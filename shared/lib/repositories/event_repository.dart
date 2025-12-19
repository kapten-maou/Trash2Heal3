import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/firebase_service.dart';

class EventRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('events');

  // CREATE
  Future<String> createEvent(EventModel event) async {
    try {
      final now = DateTime.now();
      final data = event
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      _firebase.logEvent('event_created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to create event',
        );
      }
      rethrow;
    }
  }

  // READ - Get by ID
  Future<EventModel?> getEventById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return EventModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get event by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get all active events
  Future<List<EventModel>> getActiveEvents() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: 'active')
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('endDate')
          .orderBy('startDate')
          .orderBy('isFeatured', descending: true)
          .get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get active events',
        );
      }
      rethrow;
    }
  }

  // READ - Get upcoming events
  Future<List<EventModel>> getUpcomingEvents() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: 'active')
          .where('startDate', isGreaterThan: Timestamp.fromDate(now))
          .orderBy('startDate')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get upcoming events',
        );
      }
      rethrow;
    }
  }

  // READ - Get featured events
  Future<List<EventModel>> getFeaturedEvents() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .where('status', isEqualTo: 'active')
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('startDate')
          .orderBy('endDate')
          .limit(5)
          .get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get featured events',
        );
      }
      rethrow;
    }
  }

  // READ - Get events by status
  Future<List<EventModel>> getEventsByStatus(EventStatus status) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get events by status: ${status.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get events by category
  Future<List<EventModel>> getEventsByCategory(String category) async {
    try {
      final snapshot = await _collection
          .where('categories', arrayContains: category)
          .where('isActive', isEqualTo: true)
          .orderBy('startDate', descending: true)
          .get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get events by category: $category',
        );
      }
      rethrow;
    }
  }

  // READ - Search events
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      // Note: For better search, consider using Algolia or similar
      // This is a basic implementation
      final snapshot = await _collection
          .where('isActive', isEqualTo: true)
          .orderBy('title')
          .startAt([query]).endAt([query + '\uf8ff']).get();

      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to search events: $query',
        );
      }
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateEvent(String id, Map<String, dynamic> updates) async {
    try {
      await _collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update event: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Increment participant count
  Future<void> incrementParticipantCount(String id) async {
    try {
      await _collection.doc(id).update({
        'participantCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to increment participant count: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Increment view count
  Future<void> incrementViewCount(String id) async {
    try {
      await _collection.doc(id).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to increment view count: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Change status
  Future<void> changeEventStatus(String id, EventStatus status) async {
    try {
      await _collection.doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_status_changed');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to change event status: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE (Soft delete)
  Future<void> deactivateEvent(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('event_deactivated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to deactivate event: $id',
        );
      }
      rethrow;
    }
  }

  // DELETE (Hard delete - admin only)
  Future<void> deleteEvent(String id) async {
    try {
      await _collection.doc(id).delete();

      _firebase.logEvent('event_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete event: $id',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch event
  Stream<EventModel?> watchEvent(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return EventModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch active events
  Stream<List<EventModel>> watchActiveEvents() {
    final now = DateTime.now();
    return _collection
        .where('isActive', isEqualTo: true)
        .where('status', isEqualTo: 'active')
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('startDate')
        .orderBy('endDate')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  // STREAM - Watch featured events
  Stream<List<EventModel>> watchFeaturedEvents() {
    final now = DateTime.now();
    return _collection
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .where('status', isEqualTo: 'active')
        .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(now))
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('startDate')
        .orderBy('endDate')
        .limit(5)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList());
  }

  // Convenience method aliases
  Future<List<EventModel>> getAll() => getActiveEvents();
}
