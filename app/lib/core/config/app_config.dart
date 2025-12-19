import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // App Info
  static const String appName = 'TRASH2HEAL';
  static const String appVersion = '1.0.0';

  // Helper aman untuk baca env
  static String _env(String key, {String defaultValue = ''}) {
    if (!dotenv.isInitialized) return defaultValue;
    return dotenv.env[key] ?? defaultValue;
  }

  // Environment
  static bool get isDev =>
      kDebugMode || _env('ENV', defaultValue: 'development') == 'development';

  static bool get isProd =>
      kReleaseMode || _env('ENV', defaultValue: 'development') == 'production';

  // Untuk kompatibilitas lama
  static const bool isFirebaseEnabled = true;

  // Firebase
  static String get firebaseProjectId => _env('FIREBASE_PROJECT_ID');
  static String get firebaseApiKey => _env('FIREBASE_API_KEY');

  // Google Maps
  static String get googleMapsApiKey => _env('GOOGLE_MAPS_API_KEY');

  // Payment
  static String get paymentApiKey => _env('PAYMENT_API_KEY');
  static String get paymentWebhookSecret => _env(
      'PAYMENT_WEBHOOK_SECRET'); // kalau TIDAK dipakai di Flutter, boleh dihapus
  static bool get useMockPayment =>
      _env('USE_MOCK_PAYMENT', defaultValue: 'false') == 'true';

  // Business Logic Constants
  static const int pointsToCouponRatio = 1000; // 1000 points = 1 coupon
  static const int minCashoutAmount = 50000; // Rp 50,000
  static const int pinLength = 6;
  static const double geofenceThresholdMeters = 100.0;

  // Pickup Categories
  static const List<String> pickupCategories = [
    'plastic',
    'glass',
    'can',
    'cardboard',
    'fabric',
    'ceramic_stone',
  ];

  // Category Display Names
  static const Map<String, String> categoryNames = {
    'plastic': 'Plastik',
    'glass': 'Kaca',
    'can': 'Kaleng',
    'cardboard': 'Kardus',
    'fabric': 'Kain',
    'ceramic_stone': 'Keramik/Batu',
  };

  // Category Icons
  static const Map<String, String> categoryIcons = {
    'plastic': '♻️',
    'glass': '🍾',
    'can': '🥫',
    'cardboard': '📦',
    'fabric': '👕',
    'ceramic_stone': '🪨',
  };

  /// Initialize app config
  static Future<void> initialize() async {
    try {
      // ✅ SESUAIKAN DENGAN PUBSPEC: assets/.env
      await dotenv.load(fileName: '.env');
      debugPrint('✅ App config loaded from .env');
    } catch (e) {
      debugPrint('⚠️  .env file not found, using defaults: $e');
      // lanjut dengan default value
    }

    _printConfig();
  }

  /// Print configuration (debug only)
  static void _printConfig() {
    if (isDev) {
      debugPrint('=== App Configuration ===');
      debugPrint('App Name: $appName');
      debugPrint('Version: $appVersion');
      debugPrint('Environment: ${isProd ? "Production" : "Development"}');
      debugPrint('Platform: ${kIsWeb ? "Web" : "Mobile"}');
      debugPrint('Firebase: ${isFirebaseEnabled ? "Enabled" : "Disabled"}');
      debugPrint('========================');
    }
  }

  /// Get category display name
  static String getCategoryName(String category) {
    return categoryNames[category] ?? category;
  }

  /// Get category icon
  static String getCategoryIcon(String category) {
    return categoryIcons[category] ?? '📦';
  }

  // ✅ TAMBAHAN: Helper methods for compatibility
  static const bool isProduction = kReleaseMode;
  static const bool isDevelopment = kDebugMode;

  // Points System (for compatibility with other parts)
  static const int pointsPerKgPlastic = 10;
  static const int pointsPerKgPaper = 8;
  static const int pointsPerKgMetal = 15;
  static const int pointsPerKgGlass = 12;
  static const int pointsPerKgOrganic = 5;

  // Get points for waste type
  static int getPointsForWasteType(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'plastic':
      case 'plastik':
        return pointsPerKgPlastic;
      case 'paper':
      case 'kertas':
        return pointsPerKgPaper;
      case 'metal':
      case 'logam':
        return pointsPerKgMetal;
      case 'glass':
      case 'kaca':
        return pointsPerKgGlass;
      case 'organic':
      case 'organik':
        return pointsPerKgOrganic;
      case 'can':
      case 'kaleng':
        return pointsPerKgMetal;
      case 'cardboard':
      case 'kardus':
        return pointsPerKgPaper;
      default:
        return 5; // default points
    }
  }
}
