import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'core/theme/admin_theme.dart';
import 'router/admin_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: AdminApp(),
    ),
  );
}

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(adminRouterProvider);

    return MaterialApp.router(
      title: 'TRASH2HEAL Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.lightTheme,
      darkTheme: AdminTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,

      // Error handling for the entire app
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

/// Provider for auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Provider to check if current user is admin
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  try {
    // Force token refresh to get latest claims
    await user.getIdToken(true);

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    // Check if user has admin role
    return claims?['role'] == 'admin';
  } catch (e) {
    debugPrint('Error checking admin role: $e');
    return false;
  }
});

/// Provider for current admin user info
final currentAdminProvider = StreamProvider<AdminUser?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    try {
      final idTokenResult = await user.getIdTokenResult();
      final isAdmin = idTokenResult.claims?['role'] == 'admin';

      if (!isAdmin) return null;

      return AdminUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'Admin',
        photoUrl: user.photoURL,
        role: 'admin',
      );
    } catch (e) {
      debugPrint('Error getting admin user: $e');
      return null;
    }
  });
});

/// Admin User Model
class AdminUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String role;

  AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.role,
  });

  String get initials {
    if (displayName.isEmpty) return 'A';
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName[0].toUpperCase();
  }
}
