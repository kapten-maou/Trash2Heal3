import 'dart:typed_data'; // ✅ ADD THIS IMPORT
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../firebase_options.dart';

/// Firebase service for admin dashboard
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  /// Firebase instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseFunctions get functions => FirebaseFunctions.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;

  /// Initialize Firebase
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Enable Firestore offline persistence (web)
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Set Firebase Functions region (comment out for production)
      // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => auth.currentUser != null;

  /// Get current user
  User? get currentUser => auth.currentUser;

  /// Get current user ID
  String? get currentUserId => currentUser?.uid;

  /// Sign out
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  /// Call cloud function
  Future<Map<String, dynamic>> callFunction(
    String functionName, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final callable = functions.httpsCallable(functionName);
      final result = await callable.call(parameters);
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      print('Function call error ($functionName): $e');
      rethrow;
    }
  }

  /// Upload file to storage
  /// ✅ FIXED: Convert List<int> to Uint8List
  Future<String> uploadFile(
    String path,
    List<int> bytes, {
    String? contentType,
  }) async {
    try {
      final ref = storage.ref().child(path);
      final metadata = contentType != null
          ? SettableMetadata(contentType: contentType)
          : null;

      // ✅ Convert List<int> to Uint8List
      final uint8bytes = Uint8List.fromList(bytes);

      final uploadTask = ref.putData(uint8bytes, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  /// Delete file from storage
  Future<void> deleteFile(String path) async {
    try {
      final ref = storage.ref().child(path);
      await ref.delete();
    } catch (e) {
      print('Delete file error: $e');
      rethrow;
    }
  }

  /// Get document reference
  DocumentReference doc(String path) {
    return firestore.doc(path);
  }

  /// Get collection reference
  CollectionReference collection(String path) {
    return firestore.collection(path);
  }

  /// Batch write
  WriteBatch batch() {
    return firestore.batch();
  }

  /// Transaction
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler,
  ) {
    return firestore.runTransaction(transactionHandler);
  }

  /// Enable offline persistence (web)
  Future<void> enablePersistence() async {
    try {
      await firestore.enablePersistence(
        const PersistenceSettings(synchronizeTabs: true),
      );
    } catch (e) {
      print('Enable persistence error: $e');
    }
  }

  /// Clear offline cache
  Future<void> clearPersistence() async {
    try {
      await firestore.clearPersistence();
    } catch (e) {
      print('Clear persistence error: $e');
    }
  }
}
