// File: lib/firebase_options.dart
// Firebase configuration for TRASH2HEAL

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ============================================
  // WEB CONFIGURATION (dari Firebase Console)
  // ============================================
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDx0h8yZI6UuP9VIsJt49GrZj7vKO6xPes',
    appId: '1:503352459716:web:87e2d08b2be461aa216491',
    messagingSenderId: '503352459716',
    projectId: 'trash2heal',
    authDomain: 'trash2heal.firebaseapp.com',
    storageBucket: 'trash2heal.firebasestorage.app',
    measurementId: 'G-HGDGDBF7LG',
  );

  // ============================================
  // ANDROID CONFIGURATION
  // (menggunakan config yang sama dengan web sementara)
  // ============================================
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDx0h8yZI6UuP9VIsJt49GrZj7vKO6xPes',
    appId: '1:503352459716:web:87e2d08b2be461aa216491',
    messagingSenderId: '503352459716',
    projectId: 'trash2heal',
    storageBucket: 'trash2heal.firebasestorage.app',
  );

  // ============================================
  // iOS CONFIGURATION
  // (menggunakan config yang sama dengan web sementara)
  // ============================================
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDx0h8yZI6UuP9VIsJt49GrZj7vKO6xPes',
    appId: '1:503352459716:web:87e2d08b2be461aa216491',
    messagingSenderId: '503352459716',
    projectId: 'trash2heal',
    storageBucket: 'trash2heal.firebasestorage.app',
    iosBundleId: 'com.example.trash2heal',
  );
}
