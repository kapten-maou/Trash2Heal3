import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection => _firebase.users;

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<void> createUser(UserModel user) async {
    try {
      final data = user.toJson();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _collection.doc(user.uid).set(data);
      _firebase.logEvent('User created: ${user.uid}');
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

  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _collection.doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<UserModel?> watchUser(String uid) {
    return _collection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final query =
          await _collection.where('email', isEqualTo: email).limit(1).get();

      if (query.docs.isEmpty) return null;
      return UserModel.fromFirestore(query.docs.first);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final query = await _collection
          .where('role', isEqualTo: role)
          .where('isActive', isEqualTo: true)
          .get();

      return query.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
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

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(uid).update(data);
      _firebase.logEvent('User updated: $uid');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> updatePointBalance(String uid, int newBalance) async {
    try {
      await _collection.doc(uid).update({
        'pointBalance': newBalance,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> updateMembershipTier(String uid, String tier) async {
    try {
      await _collection.doc(uid).update({
        'membershipTier': tier,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Membership updated: $uid -> $tier');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> updateFcmToken(String uid, String token) async {
    try {
      await _collection.doc(uid).update({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });
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

  Future<void> deleteUser(String uid) async {
    try {
      await _collection.doc(uid).delete();
      _firebase.logEvent('User deleted: $uid');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> deactivateUser(String uid) async {
    try {
      await _collection.doc(uid).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('User deactivated: $uid');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // Convenience method aliases
  Future<UserModel?> getById(String uid) => getUserById(uid);
  
  Future<void> create(UserModel user) => createUser(user);
  
  Future<void> update(UserModel user) => updateUser(user.uid, user.toJson());
}