// admin_web/lib/features/users/providers/users_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

// ============================================================================
// USERS STATE
// ============================================================================

class UsersState {
  final List<UserModel> users;
  final List<UserModel> filteredUsers;
  final UserModel? selectedUser;
  final Map<String, dynamic>? userStats;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? successMessage;

  // Filters
  final String? filterRole;
  final String? filterStatus;
  final String searchQuery;

  const UsersState({
    this.users = const [],
    this.filteredUsers = const [],
    this.selectedUser,
    this.userStats,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.successMessage,
    this.filterRole,
    this.filterStatus,
    this.searchQuery = '',
  });

  UsersState copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    UserModel? selectedUser,
    Map<String, dynamic>? userStats,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? successMessage,
    String? filterRole,
    String? filterStatus,
    String? searchQuery,
    bool clearSelectedUser = false,
  }) {
    return UsersState(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedUser:
          clearSelectedUser ? null : (selectedUser ?? this.selectedUser),
      userStats: clearSelectedUser ? null : (userStats ?? this.userStats),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      successMessage: successMessage,
      filterRole: filterRole ?? this.filterRole,
      filterStatus: filterStatus ?? this.filterStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ============================================================================
// HELPER: Safe property getters for UserModel
// ============================================================================

extension UserModelHelpers on UserModel {
  String get safeRole {
    try {
      return (this as dynamic).role?.toString() ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  bool get safeIsSuspended {
    try {
      return (this as dynamic).isSuspended ?? false;
    } catch (e) {
      return false;
    }
  }

  int get safePoints {
    try {
      final points = (this as dynamic).points;
      if (points is int) return points;
      if (points is double) return points.toInt();
      // Try PointsInfo if exists
      final pointsInfo = (this as dynamic).pointsInfo;
      if (pointsInfo != null) {
        final balance = (pointsInfo as dynamic).balance;
        if (balance is int) return balance;
        if (balance is double) return balance.toInt();
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}

// ============================================================================
// USERS PROVIDER
// ============================================================================

class UsersNotifier extends StateNotifier<UsersState> {
  final UserRepository _repository;
  final FirebaseFirestore _firestore;

  UsersNotifier(this._repository, this._firestore) : super(const UsersState());

  // --------------------------------------------------------------------------
  // LOAD ALL USERS
  // --------------------------------------------------------------------------

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _repository.getUsersByRole('user');

      users.sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

      state = state.copyWith(
        users: users,
        filteredUsers: users,
        isLoading: false,
      );

      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load users: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // LOAD USER BY ID
  // --------------------------------------------------------------------------

  Future<void> loadUserById(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.getById(userId);

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not found',
        );
        return;
      }

      // Load user statistics
      final stats = await _loadUserStatistics(userId);

      state = state.copyWith(
        selectedUser: user,
        userStats: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load user: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // UPDATE USER
  // --------------------------------------------------------------------------

  Future<bool> updateUser(String userId, UserModel updatedUser) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      await _repository.updateUser(userId, updatedUser.toJson());

      // Update in list
      final updatedUsers = state.users.map((u) {
        return u.uid == userId ? updatedUser : u;
      }).toList();

      state = state.copyWith(
        users: updatedUsers,
        selectedUser: state.selectedUser?.uid == userId
            ? updatedUser
            : state.selectedUser,
        isSaving: false,
        successMessage: 'User updated successfully',
      );

      _applyFilters();
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to update user: $e',
      );
      return false;
    }
  }

  // --------------------------------------------------------------------------
  // ADJUST USER POINTS (Admin action)
  // --------------------------------------------------------------------------

  Future<bool> adjustUserPoints(
    String userId,
    int pointsChange,
    String reason,
  ) async {
    state = state.copyWith(isSaving: true, error: null, successMessage: null);

    try {
      final user = state.users.firstWhere((u) => u.uid == userId);
      final currentPoints = user.safePoints;
      final newPoints = (currentPoints + pointsChange).clamp(0, 999999);

      // Update user with new points (you'll need to adjust based on actual UserModel structure)
      // For now, we'll just create a ledger entry

      // Create point ledger entry
      await _firestore.collection('point_ledger').add({
        'uid': userId,
        'delta': pointsChange,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
        'type': pointsChange > 0 ? 'credit' : 'debit',
        'source': 'admin_adjustment',
      });

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Points adjusted successfully',
      );

      // Reload user to get updated points
      await loadUserById(userId);

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to adjust points: $e',
      );
      return false;
    }
  }

  // --------------------------------------------------------------------------
  // LOAD USER STATISTICS
  // --------------------------------------------------------------------------

  Future<Map<String, dynamic>> _loadUserStatistics(String userId) async {
    try {
      // Get pickup requests count
      final pickupsSnapshot = await _firestore
          .collection('pickup_requests')
          .where('userId', isEqualTo: userId)
          .get();

      final totalPickups = pickupsSnapshot.docs.length;
      final completedPickups = pickupsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'completed')
          .length;

      // Get points history
      final pointsSnapshot = await _firestore
          .collection('point_ledger')
          .where('uid', isEqualTo: userId)
          .get();

      final pointsEarned = pointsSnapshot.docs
          .where((doc) =>
              (doc.data()['delta'] as num?) != null &&
              (doc.data()['delta'] as num) > 0)
          .fold<double>(
              0.0,
              (sum, doc) =>
                  sum + ((doc.data()['delta'] as num?)?.toDouble() ?? 0.0));

      final pointsSpent = pointsSnapshot.docs
          .where((doc) =>
              (doc.data()['delta'] as num?) != null &&
              (doc.data()['delta'] as num) < 0)
          .fold<double>(
              0.0,
              (sum, doc) =>
                  sum +
                  ((doc.data()['delta'] as num?)?.abs().toDouble() ?? 0.0));

      // Get redemptions count
      final redeemsSnapshot = await _firestore
          .collection('redeem_requests')
          .where('userId', isEqualTo: userId)
          .get();

      final totalRedemptions = redeemsSnapshot.docs.length;

      // Get event participation
      final scansSnapshot = await _firestore
          .collection('voucher_scans')
          .where('userId', isEqualTo: userId)
          .get();

      final eventsParticipated = scansSnapshot.docs
          .map((doc) => doc.data()['eventId'] as String?)
          .where((id) => id != null)
          .toSet()
          .length;

      // Get addresses count
      final addressesSnapshot = await _firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
          .get();

      // Get payment methods count
      final paymentMethodsSnapshot = await _firestore
          .collection('payment_methods')
          .where('userId', isEqualTo: userId)
          .get();

      return {
        'totalPickups': totalPickups,
        'completedPickups': completedPickups,
        'pointsEarned': pointsEarned,
        'pointsSpent': pointsSpent,
        'totalRedemptions': totalRedemptions,
        'eventsParticipated': eventsParticipated,
        'addressesCount': addressesSnapshot.docs.length,
        'paymentMethodsCount': paymentMethodsSnapshot.docs.length,
      };
    } catch (e) {
      print('Error loading user statistics: $e');
      return {
        'totalPickups': 0,
        'completedPickups': 0,
        'pointsEarned': 0.0,
        'pointsSpent': 0.0,
        'totalRedemptions': 0,
        'eventsParticipated': 0,
        'addressesCount': 0,
        'paymentMethodsCount': 0,
      };
    }
  }

  // --------------------------------------------------------------------------
  // GET USER ACTIVITY TIMELINE
  // --------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getUserActivityTimeline(
      String userId) async {
    try {
      final activities = <Map<String, dynamic>>[];

      // Get recent pickups
      final pickupsSnapshot = await _firestore
          .collection('pickup_requests')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      for (final doc in pickupsSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'type': 'pickup',
          'title': 'Pickup Request',
          'description': 'Status: ${data['status']}',
          'timestamp':
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        });
      }

      // Get recent redemptions
      final redeemsSnapshot = await _firestore
          .collection('redeem_requests')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      for (final doc in redeemsSnapshot.docs) {
        final data = doc.data();
        activities.add({
          'type': 'redeem',
          'title': 'Points Redeemed',
          'description': 'Amount: Rp ${data['amount']}',
          'timestamp':
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        });
      }

      // Sort by timestamp
      activities.sort((a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

      return activities.take(20).toList();
    } catch (e) {
      print('Error loading activity timeline: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // FILTERS
  // --------------------------------------------------------------------------

  void setRoleFilter(String? role) {
    state = state.copyWith(filterRole: role);
    _applyFilters();
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(filterStatus: status);
    _applyFilters();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void clearFilters() {
    state = state.copyWith(
      filterRole: null,
      filterStatus: null,
      searchQuery: '',
      filteredUsers: state.users,
    );
  }

  void _applyFilters() {
    var filtered = state.users;

    // Filter by role
    if (state.filterRole != null) {
      filtered =
          filtered.where((user) => user.safeRole == state.filterRole).toList();
    }

    // Filter by status
    if (state.filterStatus != null) {
      final isSuspended = state.filterStatus == 'suspended';
      filtered = filtered
          .where((user) => user.safeIsSuspended == isSuspended)
          .toList();
    }

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            (user.phone?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    state = state.copyWith(filteredUsers: filtered);
  }

  // --------------------------------------------------------------------------
  // CLEAR MESSAGES
  // --------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearSuccessMessage() {
    state = state.copyWith(successMessage: null);
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }

  // --------------------------------------------------------------------------
  // SELECT USER
  // --------------------------------------------------------------------------

  void selectUser(UserModel user) {
    state = state.copyWith(selectedUser: user);
  }

  void clearSelectedUser() {
    state = state.copyWith(clearSelectedUser: true);
  }

  // --------------------------------------------------------------------------
  // REFRESH USER DATA
  // --------------------------------------------------------------------------

  Future<void> refreshSelectedUser() async {
    if (state.selectedUser != null) {
      await loadUserById(state.selectedUser!.uid);
    }
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

// Firestore provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Users State Notifier provider
final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  final firestore = ref.watch(firestoreProvider);
  return UsersNotifier(repository, firestore);
});

// ============================================================================
// COMPUTED PROVIDERS
// ============================================================================

// All users
final allUsersProvider = Provider<List<UserModel>>((ref) {
  return ref.watch(usersProvider).users;
});

// Filtered users
final filteredUsersProvider = Provider<List<UserModel>>((ref) {
  return ref.watch(usersProvider).filteredUsers;
});

// Selected user
final selectedUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(usersProvider).selectedUser;
});

// User statistics
final userStatsProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(usersProvider).userStats;
});

// Is loading
final usersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(usersProvider).isLoading;
});

// Is saving
final usersSavingProvider = Provider<bool>((ref) {
  return ref.watch(usersProvider).isSaving;
});

// Error message
final usersErrorProvider = Provider<String?>((ref) {
  return ref.watch(usersProvider).error;
});

// Success message
final usersSuccessProvider = Provider<String?>((ref) {
  return ref.watch(usersProvider).successMessage;
});
