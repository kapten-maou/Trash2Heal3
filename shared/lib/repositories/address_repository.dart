import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../models/address_model.dart';
import '../services/firebase_service.dart';

class AddressRepository {
  final FirebaseService _firebase = FirebaseService();

  CollectionReference get _collection => _firebase.addresses;

  // ============================================================================
  // CREATE
  // ============================================================================

  Future<String> createAddress(AddressModel address) async {
    try {
      final data = address.toJson();
      data.remove('id'); // Remove id as Firestore will generate it
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _collection.add(data);
      _firebase.logEvent('Address created: ${docRef.id}');
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

  Future<AddressModel?> getAddressById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return AddressModel.fromFirestore(doc);
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<List<AddressModel>> getAddressesByUserId(String userId) async {
    try {
      final query = await _collection
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .orderBy('isPrimary', descending: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => AddressModel.fromFirestore(doc)).toList();
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Stream<List<AddressModel>> watchUserAddresses(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .orderBy('isPrimary', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AddressModel.fromFirestore(doc))
            .toList());
  }

  Future<AddressModel?> getPrimaryAddress(String userId) async {
    try {
      final query = await _collection
          .where('userId', isEqualTo: userId)
          .where('isPrimary', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return AddressModel.fromFirestore(query.docs.first);
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

  Future<void> updateAddress(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _collection.doc(id).update(data);
      _firebase.logEvent('Address updated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> setPrimaryAddress(String userId, String addressId) async {
    try {
      final batch = _firebase.batch();

      // Unset all other addresses as non-primary
      final addresses = await getAddressesByUserId(userId);
      for (final address in addresses) {
        batch.update(_collection.doc(address.id), {'isPrimary': false});
      }

      // Set selected address as primary
      batch.update(_collection.doc(addressId), {
        'isPrimary': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
      _firebase.logEvent('Primary address set: $addressId');
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

  Future<void> deleteAddress(String id) async {
    try {
      await _collection.doc(id).delete();
      _firebase.logEvent('Address deleted: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  Future<void> deactivateAddress(String id) async {
    try {
      await _collection.doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _firebase.logEvent('Address deactivated: $id');
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
      rethrow;
    }
  }

  // Convenience method aliases
  Future<String> create(AddressModel address) => createAddress(address);
  
  Future<List<AddressModel>> getByUserId(String userId) => getAddressesByUserId(userId);
  
  Future<void> update(AddressModel address) => updateAddress(address.id, address.toJson());
  
  Future<void> delete(String id) => deleteAddress(id);
}