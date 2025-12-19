import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/membership_model.dart';
import '../services/firebase_service.dart';

class MembershipRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('memberships');

  // CREATE
  Future<String> createMembership(MembershipModel membership) async {
    try {
      final now = DateTime.now();
      final data = membership
          .copyWith(
            createdAt: now,
            updatedAt: now,
          )
          .toFirestore();

      final docRef = await _collection.add(data);

      // Update user's membership tier in users collection
      await _firebase.firestore
          .collection('users')
          .doc(membership.userId)
          .update({
        'membershipTier': membership.tier.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('membership_created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to create membership',
        );
      }
      rethrow;
    }
  }

  // READ - Get by ID
  Future<MembershipModel?> getMembershipById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return MembershipModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get membership by id: $id',
        );
      }
      rethrow;
    }
  }

  // READ - Get active membership by user
  Future<MembershipModel?> getActiveMembershipByUser(String userId) async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('endDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return MembershipModel.fromFirestore(snapshot.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get active membership: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get all memberships by user
  Future<List<MembershipModel>> getMembershipsByUser(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get memberships by user: $userId',
        );
      }
      rethrow;
    }
  }

  // READ - Get memberships by tier
  Future<List<MembershipModel>> getMembershipsByTier(
    MembershipTier tier,
  ) async {
    try {
      final snapshot = await _collection
          .where('tier', isEqualTo: tier.name)
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get memberships by tier: ${tier.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get memberships by status
  Future<List<MembershipModel>> getMembershipsByStatus(
    MembershipStatus status,
  ) async {
    try {
      final snapshot = await _collection
          .where('status', isEqualTo: status.name)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get memberships by status: ${status.name}',
        );
      }
      rethrow;
    }
  }

  // READ - Get expiring memberships (within days)
  Future<List<MembershipModel>> getExpiringMemberships(int withinDays) async {
    try {
      final now = DateTime.now();
      final expiryThreshold = now.add(Duration(days: withinDays));

      final snapshot = await _collection
          .where('status', isEqualTo: 'active')
          .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('endDate',
              isLessThanOrEqualTo: Timestamp.fromDate(expiryThreshold))
          .orderBy('endDate')
          .get();

      return snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get expiring memberships',
        );
      }
      rethrow;
    }
  }

  // READ - Get auto-renewal memberships
  Future<List<MembershipModel>> getAutoRenewalMemberships() async {
    try {
      final snapshot = await _collection
          .where('autoRenew', isEqualTo: true)
          .where('status', isEqualTo: 'active')
          .orderBy('endDate')
          .get();

      return snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get auto-renewal memberships',
        );
      }
      rethrow;
    }
  }

  // READ - Get membership statistics
  Future<Map<String, int>> getMembershipStatistics() async {
    try {
      final snapshot =
          await _collection.where('status', isEqualTo: 'active').get();

      final memberships = snapshot.docs
          .map((doc) => MembershipModel.fromFirestore(doc))
          .toList();

      return {
        'total': memberships.length,
        'basic':
            memberships.where((m) => m.tier == MembershipTier.basic).length,
        'gold': memberships.where((m) => m.tier == MembershipTier.gold).length,
        'platinum':
            memberships.where((m) => m.tier == MembershipTier.platinum).length,
        'autoRenew': memberships.where((m) => m.autoRenew).length,
        'lifetime': memberships.where((m) => m.isLifetime).length,
      };
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to get membership statistics',
        );
      }
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateMembership(String id, Map<String, dynamic> updates) async {
    try {
      await _collection.doc(id).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('membership_updated');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update membership: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Upgrade tier (with transaction)
  Future<void> upgradeMembership(
    String userId,
    MembershipTier newTier,
    String paymentId,
  ) async {
    try {
      await _firebase.firestore.runTransaction((transaction) async {
        // Get current active membership
        final snapshot = await _collection
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          throw Exception('No active membership found');
        }

        final currentDoc = snapshot.docs.first;
        final current = MembershipModel.fromFirestore(currentDoc);

        // Cancel current membership
        transaction.update(currentDoc.reference, {
          'status': 'cancelled',
          'cancellationReason': 'Upgraded to ${newTier.name}',
          'cancelledAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Create new membership with upgraded tier
        final now = DateTime.now();
        final newMembership = MembershipModel(
          id: '', // Will be generated
          userId: userId,
          userName: current.userName,
          userEmail: current.userEmail,
          tier: newTier,
          status: MembershipStatus.active,
          startDate: now,
          endDate: now.add(Duration(days: 365)),
          durationMonths: 12,
          price: _getTierPrice(newTier),
          paymentId: paymentId,
          previousTier: current.tier.name,
          autoRenew: current.autoRenew,
          benefits: MembershipBenefits.forTier(newTier),
          createdAt: now,
          updatedAt: now,
        );

        transaction.set(
          _collection.doc(),
          newMembership.toFirestore(),
        );

        // Update user tier
        transaction.update(
          _firebase.firestore.collection('users').doc(userId),
          {
            'membershipTier': newTier.name,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      });

      _firebase.logEvent('membership_upgraded');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to upgrade membership: $userId',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Renew membership
  Future<String> renewMembership(String id, String paymentId) async {
    try {
      final membership = await getMembershipById(id);
      if (membership == null) {
        throw Exception('Membership not found');
      }

      final now = DateTime.now();
      final newEndDate = membership.endDate.isAfter(now)
          ? membership.endDate.add(Duration(days: 365))
          : now.add(Duration(days: 365));

      await _collection.doc(id).update({
        'status': 'active',
        'endDate': Timestamp.fromDate(newEndDate),
        'renewalDate': FieldValue.serverTimestamp(),
        'renewalPaymentId': paymentId,
        'renewalCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('membership_renewed');

      return id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to renew membership: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Toggle auto-renewal
  Future<void> toggleAutoRenewal(String id, bool autoRenew) async {
    try {
      await _collection.doc(id).update({
        'autoRenew': autoRenew,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('membership_auto_renew_toggled');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to toggle auto-renewal: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Update usage stats
  Future<void> updateUsageStats(
    String id,
    Map<String, dynamic> stats,
  ) async {
    try {
      await _collection.doc(id).update({
        'usageStats': stats,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to update usage stats: $id',
        );
      }
      rethrow;
    }
  }

  // UPDATE - Cancel membership
  Future<void> cancelMembership(String id, String reason) async {
    try {
      final membership = await getMembershipById(id);
      if (membership == null) {
        throw Exception('Membership not found');
      }

      await _collection.doc(id).update({
        'status': 'cancelled',
        'cancellationReason': reason,
        'cancelledAt': FieldValue.serverTimestamp(),
        'autoRenew': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Revert user tier to basic
      await _firebase.firestore
          .collection('users')
          .doc(membership.userId)
          .update({
        'membershipTier': 'basic',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _firebase.logEvent('membership_cancelled');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to cancel membership: $id',
        );
      }
      rethrow;
    }
  }

  // BATCH - Expire memberships (scheduled job)
  Future<int> expireMemberships() async {
    try {
      final now = DateTime.now();
      final snapshot = await _collection
          .where('status', isEqualTo: 'active')
          .where('endDate', isLessThan: Timestamp.fromDate(now))
          .get();

      final batch = _firebase.firestore.batch();

      for (final doc in snapshot.docs) {
        final membership = MembershipModel.fromFirestore(doc);

        batch.update(doc.reference, {
          'status': 'expired',
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Revert user tier to basic
        batch.update(
          _firebase.firestore.collection('users').doc(membership.userId),
          {
            'membershipTier': 'basic',
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }

      await batch.commit();

      _firebase.logEvent('memberships_expired');

      return snapshot.docs.length;
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to expire memberships',
        );
      }
      rethrow;
    }
  }

  // DELETE (Hard delete - admin only)
  Future<void> deleteMembership(String id) async {
    try {
      await _collection.doc(id).delete();

      _firebase.logEvent('membership_deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await _firebase.crashlytics?.recordError(
          e,
          stack,
          reason: 'Failed to delete membership: $id',
        );
      }
      rethrow;
    }
  }

  // STREAM - Watch membership
  Stream<MembershipModel?> watchMembership(String id) {
    return _collection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return MembershipModel.fromFirestore(doc);
    });
  }

  // STREAM - Watch active membership by user
  Stream<MembershipModel?> watchActiveMembershipByUser(String userId) {
    final now = DateTime.now();
    return _collection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('endDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return MembershipModel.fromFirestore(snapshot.docs.first);
    });
  }

  // STREAM - Watch memberships by user
  Stream<List<MembershipModel>> watchMembershipsByUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MembershipModel.fromFirestore(doc))
            .toList());
  }

  // Helper - Get tier price
  int _getTierPrice(MembershipTier tier) {
    switch (tier) {
      case MembershipTier.basic:
        return 0;
      case MembershipTier.gold:
        return 99000; // IDR per year
      case MembershipTier.platinum:
        return 299000; // IDR per year
    }
  }

  // Convenience method aliases
  Future<List<MembershipModel>> getByUserId(String userId) =>
      getMembershipsByUser(userId);
  
  Future<String> create(MembershipModel membership) =>
      createMembership(membership);
}