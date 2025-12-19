import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/point_ledger_model.dart';
import '../services/firebase_service.dart';

/// Repository for managing point transaction ledger
/// Handles all point earning and redemption transactions
class PointLedgerRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection =>
      _firebase.firestore.collection('pointLedgers');

  // ==================== CREATE ====================

  /// Create new ledger entry
  /// This should be called within a transaction to ensure balance consistency
  Future<String> createLedgerEntry(PointLedgerModel ledger) async {
    try {
      final data = ledger.toFirestore();
      data['createdAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Point ledger created');

      return docRef.id;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance
            .recordError(e, stack, reason: 'Failed to create point ledger');
      }
      rethrow;
    }
  }

  /// Record point earning (from pickups, events, bonuses)
  Future<String> recordEarn({
    required String userId,
    required int amount,
    required String description,
    String? relatedId,
    String? relatedCollection,
    Map<String, dynamic>? metadata,
  }) async {
    final ledger = PointLedgerModel(
      id: '',
      userId: userId,
      type: PointTransactionType.earn,
      amount: amount,
      description: description,
      relatedId: relatedId,
      relatedCollection: relatedCollection,
      metadata: metadata,
    );

    return await createLedgerEntry(ledger);
  }

  /// Record point redemption (for vouchers, balance)
  Future<String> recordRedeem({
    required String userId,
    required int amount,
    required String description,
    String? relatedId,
    String? relatedCollection,
    Map<String, dynamic>? metadata,
  }) async {
    final ledger = PointLedgerModel(
      id: '',
      userId: userId,
      type: PointTransactionType.redeem,
      amount: -amount, // Negative for deduction
      description: description,
      relatedId: relatedId,
      relatedCollection: relatedCollection,
      metadata: metadata,
    );

    return await createLedgerEntry(ledger);
  }

  /// Record refund (return points)
  Future<String> recordRefund({
    required String userId,
    required int amount,
    required String description,
    String? relatedId,
    Map<String, dynamic>? metadata,
  }) async {
    final ledger = PointLedgerModel(
      id: '',
      userId: userId,
      type: PointTransactionType.refund,
      amount: amount,
      description: description,
      relatedId: relatedId,
      metadata: metadata,
    );

    return await createLedgerEntry(ledger);
  }

  // ==================== READ ====================

  /// Get ledger entry by ID
  Future<PointLedgerModel?> getLedgerById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return PointLedgerModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get all ledger entries for a user
  Future<List<PointLedgerModel>> getUserLedger(
    String userId, {
    int? limit,
  }) async {
    try {
      Query query = _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PointLedgerModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get ledger entries by type
  Future<List<PointLedgerModel>> getUserLedgerByType(
    String userId,
    PointTransactionType type, {
    int? limit,
  }) async {
    try {
      Query query = _collection
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type.name)
          .orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PointLedgerModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get ledger entries by related ID (e.g., all transactions for a pickup)
  Future<List<PointLedgerModel>> getLedgerByRelatedId(String relatedId) async {
    try {
      final snapshot = await _collection
          .where('relatedId', isEqualTo: relatedId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PointLedgerModel.fromFirestore(doc))
          .toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ==================== STREAMS ====================

  /// Watch user's ledger in real-time
  Stream<List<PointLedgerModel>> watchUserLedger(String userId, {int? limit}) {
    Query query = _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PointLedgerModel.fromFirestore(doc))
        .toList());
  }

  // ==================== ANALYTICS ====================

  /// Calculate total earned points for a user
  Future<int> calculateTotalEarned(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('type', whereIn: [
        PointTransactionType.earn.name,
        PointTransactionType.bonus.name,
        PointTransactionType.refund.name,
      ]).get();

      int total = 0;
      for (var doc in snapshot.docs) {
        final ledger = PointLedgerModel.fromFirestore(doc);
        total += ledger.amount;
      }
      return total;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Calculate total redeemed points for a user
  Future<int> calculateTotalRedeemed(String userId) async {
    try {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .where('type', whereIn: [
        PointTransactionType.redeem.name,
        PointTransactionType.penalty.name,
      ]).get();

      int total = 0;
      for (var doc in snapshot.docs) {
        final ledger = PointLedgerModel.fromFirestore(doc);
        total += ledger.amount.abs(); // Get absolute value
      }
      return total;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Calculate current point balance (total earned - total redeemed)
  Future<int> calculateBalance(String userId) async {
    try {
      final snapshot =
          await _collection.where('userId', isEqualTo: userId).get();

      int balance = 0;
      for (var doc in snapshot.docs) {
        final ledger = PointLedgerModel.fromFirestore(doc);
        balance += ledger.amount;
      }
      return balance;
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // ==================== DELETE ====================

  /// Delete ledger entry (admin only - use with caution!)
  Future<void> deleteLedgerEntry(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Point ledger deleted');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }
}
