import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class ProfileProvider extends ChangeNotifier {
  final UserRepository _userRepo;
  final AddressRepository _addressRepo;

  ProfileProvider(this._userRepo, this._addressRepo);

  UserModel? _currentUser;
  List<AddressModel> _addresses = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  List<AddressModel> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load current user
  Future<void> loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userRepo.getById(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = _currentUser!.copyWith(
        name: name,
        phone: phone,
        photoUrl: photoUrl,
        updatedAt: DateTime.now(),
      );

      await _userRepo.update(updated);
      _currentUser = updated;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Upload profile photo
  Future<String?> uploadProfilePhoto(Uint8List imageBytes) async {
    if (_currentUser == null) return null;

    try {
      final service = FirebaseService();
      final url = await service.uploadImage(
        imageBytes,
        'profile_pictures/${_currentUser!.uid}/profile.jpg',
      );
      return url;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Load addresses
  Future<void> loadAddresses() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await _addressRepo.getByUserId(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add address
  Future<bool> addAddress(AddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addressRepo.create(address);
      await loadAddresses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update address
  Future<bool> updateAddress(AddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addressRepo.update(address);
      await loadAddresses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _addressRepo.delete(addressId);
      await loadAddresses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Set primary address
  Future<bool> setPrimaryAddress(String addressId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;

      // Unset all primary
      for (var addr in _addresses) {
        if (addr.isPrimary) {
          await _addressRepo.update(addr.copyWith(isPrimary: false));
        }
      }

      // Set new primary
      final address = _addresses.firstWhere((a) => a.id == addressId);
      await _addressRepo.update(address.copyWith(isPrimary: true));

      await loadAddresses();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return false;

      // Re-authenticate
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

// Provider
final profileProvider = ChangeNotifierProvider<ProfileProvider>((ref) {
  final userRepo = UserRepository();
  final addressRepo = AddressRepository();
  return ProfileProvider(userRepo, addressRepo);
});
