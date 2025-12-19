import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FCM Service for handling push notifications
class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _currentToken;
  StreamController<RemoteMessage>? _messageStreamController;

  // ============================================
  // INITIALIZATION
  // ============================================

  /// Initialize FCM service
  Future<void> initialize() async {
    print('🔔 Initializing FCM Service...');

    // 1. Request permission (iOS)
    await _requestPermission();

    // 2. Initialize local notifications
    await _initializeLocalNotifications();

    // 3. Get FCM token
    await _getFCMToken();

    // 4. Setup message handlers
    _setupMessageHandlers();

    // 5. Handle background messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    print('✅ FCM Service initialized');
  }

  // ============================================
  // PERMISSION
  // ============================================

  Future<void> _requestPermission() async {
    // Android 13+ also requires POST_NOTIFICATIONS permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('FCM Permission status: ${settings.authorizationStatus}');
  }

  // ============================================
  // LOCAL NOTIFICATIONS
  // ============================================

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'default',
        'Default Notifications',
        description: 'Default notification channel',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  // ============================================
  // FCM TOKEN
  // ============================================

  Future<void> _getFCMToken() async {
    try {
      final token = await _messaging.getToken();
      
      if (token != null) {
        _currentToken = token;
        print('📱 FCM Token: ${token.substring(0, 20)}...');
        
        // Save to Firestore
        await _saveTokenToFirestore(token);

        // Listen for token refresh
        _messaging.onTokenRefresh.listen((newToken) async {
          _currentToken = newToken;
          await _saveTokenToFirestore(newToken);
        });
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('✅ FCM token saved to Firestore');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  /// Remove token from Firestore (on logout)
  Future<void> removeToken() async {
    final user = _auth.currentUser;
    if (user == null || _currentToken == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmTokens': FieldValue.arrayRemove([_currentToken!]),
      });

      print('✅ FCM token removed from Firestore');
    } catch (e) {
      print('Error removing FCM token: $e');
    }
  }

  // ============================================
  // MESSAGE HANDLERS
  // ============================================

  void _setupMessageHandlers() {
    // Initialize stream controller
    _messageStreamController = StreamController<RemoteMessage>.broadcast();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Foreground message received');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');

      // Show local notification
      _showLocalNotification(message);

      // Emit to stream
      _messageStreamController?.add(message);
    });

    // Handle notification tapped (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📨 Notification tapped (background)');
      _handleNotificationTap(message.data);
    });

    // Check for initial message (app launched from notification)
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('📨 App launched from notification');
        _handleNotificationTap(message.data);
      }
    });
  }

  /// Show local notification (when app is in foreground)
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'default',
      'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['screen'], // For navigation
    );
  }

  // ============================================
  // NOTIFICATION NAVIGATION
  // ============================================

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      print('📨 Local notification tapped: $payload');
      _navigateToScreen(payload);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    final screen = data['screen'] as String?;
    if (screen != null) {
      _navigateToScreen(screen);
    }
  }

  void _navigateToScreen(String screen) {
    // This will be implemented in app router
    // For now, just print
    print('🔗 Navigate to: $screen');
    
    // TODO: Implement navigation
    // Example: navigatorKey.currentState?.pushNamed(screen);
  }

  // ============================================
  // TOPIC SUBSCRIPTION
  // ============================================

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe to role-based topics
  Future<void> subscribeToRoleTopics(String role) async {
    // Subscribe to all users topic
    await subscribeToTopic('all_users');

    // Subscribe to role-specific topic
    switch (role) {
      case 'user':
        await subscribeToTopic('users');
        break;
      case 'courier':
        await subscribeToTopic('couriers');
        break;
      case 'admin':
        await subscribeToTopic('admins');
        break;
    }
  }

  /// Unsubscribe from all topics
  Future<void> unsubscribeFromAllTopics() async {
    await unsubscribeFromTopic('all_users');
    await unsubscribeFromTopic('users');
    await unsubscribeFromTopic('couriers');
    await unsubscribeFromTopic('admins');
  }

  // ============================================
  // MESSAGE STREAM
  // ============================================

  /// Get stream of messages (for listening in UI)
  Stream<RemoteMessage>? get messageStream => _messageStreamController?.stream;

  // ============================================
  // CLEANUP
  // ============================================

  void dispose() {
    _messageStreamController?.close();
  }

  // ============================================
  // GETTERS
  // ============================================

  String? get currentToken => _currentToken;
}

// ============================================
// BACKGROUND MESSAGE HANDLER
// ============================================

/// Handle background messages (must be top-level function)
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print('📨 Background message received');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');

  // Process notification in background
  // Can save to local storage, update badge, etc.
}

// ============================================
// PROVIDER (for Riverpod)
// ============================================



/// FCM Service provider
final fcmServiceProvider = Provider<FCMService>((ref) {
  final service = FCMService();
  ref.onDispose(service.dispose);
  return service;
});

/// Stream provider for FCM messages
final fcmMessageStreamProvider = StreamProvider<RemoteMessage>((ref) {
  final fcmService = ref.watch(fcmServiceProvider);
  return fcmService.messageStream ?? const Stream.empty();
});
