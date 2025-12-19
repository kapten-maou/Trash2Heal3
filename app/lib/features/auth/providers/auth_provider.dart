import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

/// User role enum
enum UserRole {
  user,
  courier,
  guest,
}

// Whitelisted courier emails (bypass domain check)
const Set<String> kCourierEmailWhitelist = {
  'kurir@trash2heal.com',
  'courier@trash2heal.com',
};

// Access code khusus untuk kurir
const String kCourierAccessCode = 'KURIR-1234';

/// Auth state
class AuthState {
  final UserModel? user;
  final UserRole? role;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.role,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => user != null && role != UserRole.guest;
  bool get isGuest => role == UserRole.guest;
  bool get isUser => role == UserRole.user;
  bool get isCourier => role == UserRole.courier;

  AuthState copyWith({
    UserModel? user,
    UserRole? role,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthNotifier(this._auth, this._firestore) : super(const AuthState()) {
    _checkAuthState();
  }

  /// Check initial auth state
  Future<void> _checkAuthState() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        final doc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (doc.exists) {
          final userModel = UserModel.fromFirestore(doc);
          final role =
              userModel.role == 'courier' ? UserRole.courier : UserRole.user;
          state = state.copyWith(user: userModel, role: role);
        }
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
      }
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
    required UserRole role,
    String? courierAccessCode,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Hard-coded courier login bypass (local/dev only)
    if (role == UserRole.courier &&
        email.trim().toLowerCase() == 'courier@trash2heal.com' &&
        password == 'Courier123!') {
      final courierUser = UserModel(
        uid: 'courier-local',
        email: email.trim(),
        name: 'Courier Lokal',
        phone: '-',
        role: 'courier',
        pointBalance: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      state = state.copyWith(
        user: courierUser,
        role: UserRole.courier,
        isLoading: false,
        errorMessage: null,
      );
      return true;
    }

    // Restriksi domain kurir dinonaktifkan: email kurir bebas, pastikan role di Firestore = courier

    // Check akses code kurir
    // Akses code dinonaktifkan (tidak wajib)

    try {
      // Sign in with Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final doc =
          await _firestore.collection('users').doc(credential.user!.uid).get();

      if (!doc.exists) {
        throw 'User data not found';
      }

      final userModel = UserModel.fromFirestore(doc);

      // Verify role matches
      final userRole =
          userModel.role == 'courier' ? UserRole.courier : UserRole.user;
      if (userRole != role) {
        await _auth.signOut();
        throw 'Invalid credentials for selected role';
      }

      state = state.copyWith(
        user: userModel,
        role: userRole,
        isLoading: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-disabled':
          message = 'Akun telah dinonaktifkan';
          break;
        default:
          message = 'Login gagal: ${e.message}';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        role: 'user', // Default role
        pointBalance: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      state = state.copyWith(
        user: userModel,
        role: UserRole.user,
        isLoading: false,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        default:
          message = 'Registrasi gagal: ${e.message}';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Login as guest
  void loginAsGuest() {
    final guestUser = UserModel(
      uid: 'guest',
      email: 'guest@trash2heal',
      name: 'Tamu',
      phone: '-',
      role: 'guest',
      pointBalance: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(
      user: guestUser,
      role: UserRole.guest,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    state = const AuthState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider instances
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});
