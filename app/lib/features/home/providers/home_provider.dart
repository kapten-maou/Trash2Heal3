import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';

/// Home state
class HomeState {
  final UserModel? user;
  final MembershipModel? membership;
  final int pointBalance;
  final List<EventModel> events;
  final bool isLoading;
  final String? errorMessage;
  final int? voucherCount;
  final int? voucherValue;
  final int? notificationsCount;

  const HomeState({
    this.user,
    this.membership,
    this.pointBalance = 0,
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
    this.voucherCount,
    this.voucherValue,
    this.notificationsCount,
  });

  HomeState copyWith({
    UserModel? user,
    MembershipModel? membership,
    int? pointBalance,
    List<EventModel>? events,
    bool? isLoading,
    String? errorMessage,
    int? voucherCount,
    int? voucherValue,
    int? notificationsCount,
  }) {
    return HomeState(
      user: user ?? this.user,
      membership: membership ?? this.membership,
      pointBalance: pointBalance ?? this.pointBalance,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      voucherCount: voucherCount ?? this.voucherCount,
      voucherValue: voucherValue ?? this.voucherValue,
      notificationsCount: notificationsCount ?? this.notificationsCount,
    );
  }
}

/// Home notifier
class HomeNotifier extends StateNotifier<HomeState> {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  HomeNotifier(this._firestore, this._ref) : super(const HomeState()) {
    _init();
  }

  Future<void> _init() async {
    final authState = _ref.read(authProvider);
    if (authState.isGuest) {
      // Populate minimal guest info without hitting Firestore
      state = state.copyWith(
        user: authState.user,
        membership: null,
        pointBalance: 0,
        isLoading: false,
      );
      return;
    }
    if (authState.isAuthenticated) {
      await loadHomeData();
    }
  }

  /// Load all home data
  Future<void> loadHomeData() async {
    final authState = _ref.read(authProvider);
    if (authState.isGuest) {
      state = state.copyWith(
        user: authState.user,
        membership: null,
        pointBalance: 0,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (authState.user == null) return;

      final userId = authState.user!.uid;

      // Load user data (fallback to auth user if doc belum ada)
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final user = userDoc.exists
          ? UserModel.fromFirestore(userDoc)
          : authState.user; // fallback minimal info

      // Load membership (if exists)
      MembershipModel? membership;
      final membershipQuery = await _firestore
          .collection('memberships')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (membershipQuery.docs.isNotEmpty) {
        membership = MembershipModel.fromFirestore(membershipQuery.docs.first);
      }

      // Load active events
      final eventsQuery = await _firestore
          .collection('events')
          .where('active', isEqualTo: true)
          .orderBy('startDate', descending: true)
          .limit(5)
          .get();

      final events =
          eventsQuery.docs.map((doc) => EventModel.fromFirestore(doc)).toList();

      // (Optional) Load vouchers & notifications (best-effort)
      int? voucherCount;
      int? voucherValue;
      int? notifCount;
      try {
        final voucherSnap = await _firestore
            .collection('vouchers')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .get();
        voucherCount = voucherSnap.docs.length;
        voucherValue = voucherSnap.docs.fold<int>(
            0, (sum, doc) => sum + (doc.data()['value'] as int? ?? 0));
      } catch (_) {}

      try {
        final notifSnap = await _firestore
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .where('read', isEqualTo: false)
            .get();
        notifCount = notifSnap.docs.length;
      } catch (_) {}

      state = state.copyWith(
        user: user,
        membership: membership,
        pointBalance: user?.pointBalance ?? 0,
        events: events,
        isLoading: false,
        voucherCount: voucherCount,
        voucherValue: voucherValue,
        notificationsCount: notifCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        // fallback minimal user so UI tidak stuck spinner meski Firestore error
        user: authState.user,
        membership: null,
        errorMessage: e.toString(),
      );
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadHomeData();
  }
}

/// Provider
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(FirebaseFirestore.instance, ref);
});
