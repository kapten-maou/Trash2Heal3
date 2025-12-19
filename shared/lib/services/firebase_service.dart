import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Centralized Firebase service for easy access across the app
class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  /// Initialize Firebase services (Firestore, FCM, Crashlytics, etc.)
  static Future<void> initialize() async {
    try {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }
    } catch (e, stack) {
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack);
      }
    }
  }

  // Firebase instances
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  FirebaseCrashlytics? get crashlytics =>
      kIsWeb ? null : FirebaseCrashlytics.instance;

  // Current user
  User? get currentUser => auth.currentUser;
  String? get currentUserId => currentUser?.uid;
  bool get isLoggedIn => currentUser != null;

  // Collection references
  CollectionReference get users => firestore.collection('users');
  CollectionReference get addresses => firestore.collection('addresses');
  CollectionReference get paymentMethods =>
      firestore.collection('paymentMethods');
  CollectionReference get pickupRequests =>
      firestore.collection('pickupRequests');
  CollectionReference get pickupSlots => firestore.collection('pickupSlots');
  CollectionReference get pickupRates => firestore.collection('pickupRates');
  CollectionReference get pickupTasks => firestore.collection('pickupTasks');
  CollectionReference get pointLedgers => firestore.collection('pointLedgers');
  CollectionReference get coupons => firestore.collection('coupons');
  CollectionReference get redeemRequests =>
      firestore.collection('redeemRequests');
  CollectionReference get events => firestore.collection('events');
  CollectionReference get eventItems => firestore.collection('eventItems');
  CollectionReference get voucherScans => firestore.collection('voucherScans');
  CollectionReference get memberships => firestore.collection('memberships');
  CollectionReference get payments => firestore.collection('payments');
  CollectionReference get notifications =>
      firestore.collection('notifications');
  CollectionReference get chatThreads => firestore.collection('chatThreads');
  CollectionReference get chatMessages => firestore.collection('chatMessages');

  // Storage references
  Reference get storageRef => storage.ref();
  Reference get profilePicturesRef => storageRef.child('profile_pictures');
  Reference get proofPhotosRef => storageRef.child('proof_photos');
  Reference get eventImagesRef => storageRef.child('event_images');
  Reference get chatImagesRef => storageRef.child('chat_images');

  /// Upload file to Firebase Storage
  ///
  /// Returns download URL on success
  Future<String> uploadFile({
    required File file,
    required String path,
    String? contentType,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = storageRef.child(path);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: contentType),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      // Wait for completion
      await uploadTask;

      // Get download URL
      return await ref.getDownloadURL();
    } catch (e, stack) {
      if (!kIsWeb) {
        await crashlytics?.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String path) async {
    try {
      await storageRef.child(path).delete();
    } catch (e, stack) {
      if (!kIsWeb) {
        await crashlytics?.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Get file download URL from storage path
  Future<String> getDownloadUrl(String path) async {
    try {
      return await storageRef.child(path).getDownloadURL();
    } catch (e, stack) {
      if (!kIsWeb) {
        await crashlytics?.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Upload image bytes to Firebase Storage
  /// Returns download URL on success
  Future<String> uploadImage(
    Uint8List imageBytes,
    String path, {
    Function(double)? onProgress,
  }) async {
    try {
      final ref = storageRef.child(path);
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((snapshot) {
        if (onProgress != null) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        }
      });

      // Wait for completion
      await uploadTask;

      // Get download URL
      return await ref.getDownloadURL();
    } catch (e, stack) {
      if (!kIsWeb) {
        await crashlytics?.recordError(e, stack);
      }
      rethrow;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Enable Firestore persistence (offline support)
  Future<void> enablePersistence() async {
    if (!kIsWeb) {
      await firestore.settings.persistenceEnabled;
    }
  }

  /// Log custom event to Crashlytics
  void logEvent(String message) {
    if (!kIsWeb) {
      crashlytics?.log(message);
    }
  }

  /// Record error to Crashlytics
  Future<void> recordError(dynamic error, StackTrace stack) async {
    if (!kIsWeb) {
      await crashlytics?.recordError(error, stack);
    }
  }

  /// Set user identifier for Crashlytics
  Future<void> setUserIdentifier(String userId) async {
    if (!kIsWeb) {
      await crashlytics?.setUserIdentifier(userId);
    }
  }

  /// Batch write helper
  WriteBatch batch() => firestore.batch();

  /// Transaction helper
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler,
  ) async {
    return await firestore.runTransaction(transactionHandler);
  }
}

// Global instance for easy access
final firebaseService = FirebaseService();
