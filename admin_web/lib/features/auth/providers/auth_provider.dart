// admin_web/lib/features/auth/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ ADD THIS
import 'package:trash2heal_shared/trash2heal_shared.dart';

// ============================================================================
// AUTH STATE
// ============================================================================

class AuthState {
  final User? firebaseUser;
  final UserModel? userModel;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.firebaseUser,
    this.userModel,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => firebaseUser != null && userModel != null;

  // Cek peran admin berdasarkan field role di userModel (string 'admin')
  bool get isAdmin => (userModel?.role.toLowerCase() == 'admin');

  // (OPSIONAL) kalau kamu mau bisa tetap pakai authState.user di widget lain:
  UserModel? get user => userModel;

  AuthState copyWith({
    User? firebaseUser,
    UserModel? userModel,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      firebaseUser: firebaseUser ?? this.firebaseUser,
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ============================================================================
// AUTH PROVIDER
// ============================================================================

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  final UserRepository _userRepository;

  AuthNotifier(this._auth, this._userRepository) : super(const AuthState()) {
    // Listen to auth state changes
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  // --------------------------------------------------------------------------
  // AUTH STATE LISTENER
  // --------------------------------------------------------------------------

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      state = const AuthState();
      return;
    }

    try {
      // Fetch user data from Firestore
      UserModel? userModel = await _userRepository.getById(user.uid);

      // Auto-create admin doc if missing (helps avoid bounce when user exists in Auth only)
      if (userModel == null) {
        userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Admin',
          role: 'admin',
          pointBalance: 0,
          phone: user.phoneNumber ?? '',
          membershipTier: 'silver',
          isActive: true,
          createdAt: DateTime.now(),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
      }

      // Verify admin role (pakai string "role")
      final role = userModel.role.toLowerCase();
      if (role != 'admin') {
        await _auth.signOut();
        state = const AuthState(error: 'Access denied: Admin role required');
        return;
      }

      state = AuthState(firebaseUser: user, userModel: userModel);
    } catch (e) {
      state = AuthState(error: 'Failed to load user data: $e');
    }
  }

  // --------------------------------------------------------------------------
  // LOGIN
  // --------------------------------------------------------------------------

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Login failed: No user returned');
      }

      // User data will be loaded by _onAuthStateChanged
      // Just wait a bit for the listener to fire
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if still loading or if there's an error
      if (state.error != null) {
        // Error was set by _onAuthStateChanged (e.g., not admin)
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'user-disabled':
          errorMessage = 'Akun telah dinonaktifkan';
          break;
        case 'too-many-requests':
          errorMessage = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          errorMessage = 'Login gagal: ${e.message}';
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login gagal: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // LOGOUT
  // --------------------------------------------------------------------------

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _auth.signOut();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Logout gagal: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // REFRESH USER DATA
  // --------------------------------------------------------------------------

  Future<void> refreshUser() async {
    final userId = state.firebaseUser?.uid;
    if (userId == null) return;

    try {
      final userModel = await _userRepository.getById(userId);
      if (userModel != null) {
        state = state.copyWith(userModel: userModel);
      }
    } catch (e) {
      // Silent fail - keep existing user data
      print('Failed to refresh user data: $e');
    }
  }

  // --------------------------------------------------------------------------
  // CLEAR ERROR
  // --------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(error: null);
  }

  // --------------------------------------------------------------------------
  // CHECK SESSION
  // --------------------------------------------------------------------------

  Future<bool> checkSession() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      // Verify token is still valid
      await user.getIdToken(true);
      return true;
    } catch (e) {
      return false;
    }
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

// Firebase Auth instance provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// ✅ NEW: Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ✅ versi yang benar (cukup panggil tanpa argumen)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Auth State Notifier provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return AuthNotifier(auth, userRepository);
});

// ============================================================================
// COMPUTED PROVIDERS (for convenience)
// ============================================================================

// Is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// Is admin
final isAdminProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAdmin;
});

// Current user
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).userModel;
});

// Is loading
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

// Error message
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});
