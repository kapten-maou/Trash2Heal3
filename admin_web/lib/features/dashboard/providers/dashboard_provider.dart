// admin_web/lib/features/dashboard/providers/dashboard_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';



// ============================================================================
// DASHBOARD STATISTICS MODEL
// ============================================================================

class DashboardStats {
  final int totalUsers;
  final int activeUsers; // Users with pickups in last 30 days
  final int totalPickups;
  final int pendingPickups;
  final int completedPickups;
  final double totalPoints;
  final double totalRevenue;
  final int activeCouriers;

  const DashboardStats({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalPickups = 0,
    this.pendingPickups = 0,
    this.completedPickups = 0,
    this.totalPoints = 0.0,
    this.totalRevenue = 0.0,
    this.activeCouriers = 0,
  });

  DashboardStats copyWith({
    int? totalUsers,
    int? activeUsers,
    int? totalPickups,
    int? pendingPickups,
    int? completedPickups,
    double? totalPoints,
    double? totalRevenue,
    int? activeCouriers,
  }) {
    return DashboardStats(
      totalUsers: totalUsers ?? this.totalUsers,
      activeUsers: activeUsers ?? this.activeUsers,
      totalPickups: totalPickups ?? this.totalPickups,
      pendingPickups: pendingPickups ?? this.pendingPickups,
      completedPickups: completedPickups ?? this.completedPickups,
      totalPoints: totalPoints ?? this.totalPoints,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      activeCouriers: activeCouriers ?? this.activeCouriers,
    );
  }
}

// ============================================================================
// RECENT ACTIVITY MODEL
// ============================================================================

class RecentActivity {
  final String id;
  final String type; // 'pickup', 'redeem', 'event', 'user'
  final String title;
  final String description;
  final DateTime timestamp;
  final String? userId;
  final String? userName;

  const RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.userId,
    this.userName,
  });
}

// ============================================================================
// CHART DATA MODEL
// ============================================================================

class ChartDataPoint {
  final String label;
  final double value;
  final DateTime? date;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.date,
  });
}

// ============================================================================
// DASHBOARD STATE
// ============================================================================

class DashboardState {
  final DashboardStats stats;
  final List<RecentActivity> recentActivities;
  final List<ChartDataPoint> pickupTrend; // Last 7 days
  final List<ChartDataPoint> revenueChart; // Last 6 months
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.stats = const DashboardStats(),
    this.recentActivities = const [],
    this.pickupTrend = const [],
    this.revenueChart = const [],
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    DashboardStats? stats,
    List<RecentActivity>? recentActivities,
    List<ChartDataPoint>? pickupTrend,
    List<ChartDataPoint>? revenueChart,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      stats: stats ?? this.stats,
      recentActivities: recentActivities ?? this.recentActivities,
      pickupTrend: pickupTrend ?? this.pickupTrend,
      revenueChart: revenueChart ?? this.revenueChart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ============================================================================
// DASHBOARD PROVIDER
// ============================================================================

class DashboardNotifier extends StateNotifier<DashboardState> {
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;
  final PickupRepository _pickupRepository;
  final PaymentRepository _paymentRepository;

  DashboardNotifier(
    this._firestore,
    this._userRepository,
    this._pickupRepository,
    this._paymentRepository,
  ) : super(const DashboardState());

  // --------------------------------------------------------------------------
  // LOAD ALL DASHBOARD DATA
  // --------------------------------------------------------------------------

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load all data in parallel
      final results = await Future.wait([
        _loadStats(),
        _loadRecentActivities(),
        _loadPickupTrend(),
        _loadRevenueChart(),
      ]);

      state = DashboardState(
        stats: results[0] as DashboardStats,
        recentActivities: results[1] as List<RecentActivity>,
        pickupTrend: results[2] as List<ChartDataPoint>,
        revenueChart: results[3] as List<ChartDataPoint>,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load dashboard: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // LOAD STATISTICS
  // --------------------------------------------------------------------------

  Future<DashboardStats> _loadStats() async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Total users
      final usersSnapshot = await _firestore.collection('users').get();
      final totalUsers = usersSnapshot.docs.length;

      // Active users (users with role 'user')
      final activeUsersCount = usersSnapshot.docs
          .where((doc) => doc.data()['role'] == 'user')
          .length;

      // Active couriers
      final activeCouriers = usersSnapshot.docs
          .where((doc) => doc.data()['role'] == 'courier')
          .length;

      // Pickup statistics
      final pickupsSnapshot =
          await _firestore.collection('pickup_requests').get();

      final totalPickups = pickupsSnapshot.docs.length;
      final pendingPickups = pickupsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'pending')
          .length;
      final completedPickups = pickupsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'completed')
          .length;

      // Total points distributed
      final pointsSnapshot = await _firestore
          .collection('point_ledger')
          .where('type', isEqualTo: 'earned')
          .get();

      final totalPoints = pointsSnapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['amount'] as num).toDouble(),
      );

      // Total revenue from payments
      final paymentsSnapshot = await _firestore
          .collection('payments')
          .where('status', isEqualTo: 'completed')
          .get();

      final totalRevenue = paymentsSnapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['amount'] as num).toDouble(),
      );

      return DashboardStats(
        totalUsers: totalUsers,
        activeUsers: activeUsersCount,
        totalPickups: totalPickups,
        pendingPickups: pendingPickups,
        completedPickups: completedPickups,
        totalPoints: totalPoints,
        totalRevenue: totalRevenue,
        activeCouriers: activeCouriers,
      );
    } catch (e) {
      print('Error loading stats: $e');
      return const DashboardStats();
    }
  }

  // --------------------------------------------------------------------------
  // LOAD RECENT ACTIVITIES
  // --------------------------------------------------------------------------

  Future<List<RecentActivity>> _loadRecentActivities() async {
    try {
      final activities = <RecentActivity>[];

      // Get recent pickups
      final pickupsSnapshot = await _firestore
          .collection('pickup_requests')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      for (final doc in pickupsSnapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;
        final userDoc = userId != null
            ? await _firestore.collection('users').doc(userId).get()
            : null;

        activities.add(RecentActivity(
          id: doc.id,
          type: 'pickup',
          title: 'New Pickup Request',
          description: 'Status: ${data['status'] ?? 'unknown'}',
          timestamp:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          userId: userId,
          userName: userDoc?.data()?['name'] as String?,
        ));
      }

      // Get recent redeems
      final redeemsSnapshot = await _firestore
          .collection('redeem_requests')
          .orderBy('createdAt', descending: true)
          .limit(3)
          .get();

      for (final doc in redeemsSnapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;
        final userDoc = userId != null
            ? await _firestore.collection('users').doc(userId).get()
            : null;

        activities.add(RecentActivity(
          id: doc.id,
          type: 'redeem',
          title: 'Points Redeemed',
          description: 'Amount: Rp ${data['amount'] ?? 0}',
          timestamp:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          userId: userId,
          userName: userDoc?.data()?['name'] as String?,
        ));
      }

      // Sort by timestamp
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Return top 10
      return activities.take(10).toList();
    } catch (e) {
      print('Error loading recent activities: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // LOAD PICKUP TREND (Last 7 Days)
  // --------------------------------------------------------------------------

  Future<List<ChartDataPoint>> _loadPickupTrend() async {
    try {
      final now = DateTime.now();
      final chartData = <ChartDataPoint>[];

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final snapshot = await _firestore
            .collection('pickup_requests')
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('createdAt', isLessThan: Timestamp.fromDate(endOfDay))
            .get();

        final dayLabel = _formatDayLabel(date);
        chartData.add(ChartDataPoint(
          label: dayLabel,
          value: snapshot.docs.length.toDouble(),
          date: date,
        ));
      }

      return chartData;
    } catch (e) {
      print('Error loading pickup trend: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // LOAD REVENUE CHART (Last 6 Months)
  // --------------------------------------------------------------------------

  Future<List<ChartDataPoint>> _loadRevenueChart() async {
    try {
      final now = DateTime.now();
      final chartData = <ChartDataPoint>[];

      for (int i = 5; i >= 0; i--) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        final startOfMonth = DateTime(monthDate.year, monthDate.month, 1);
        final endOfMonth = DateTime(monthDate.year, monthDate.month + 1, 1);

        final snapshot = await _firestore
            .collection('payments')
            .where('status', isEqualTo: 'completed')
            .where('createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
            .where('createdAt', isLessThan: Timestamp.fromDate(endOfMonth))
            .get();

        final totalRevenue = snapshot.docs.fold<double>(
          0.0,
          (sum, doc) => sum + (doc.data()['amount'] as num).toDouble(),
        );

        final monthLabel = _formatMonthLabel(monthDate);
        chartData.add(ChartDataPoint(
          label: monthLabel,
          value: totalRevenue,
          date: monthDate,
        ));
      }

      return chartData;
    } catch (e) {
      print('Error loading revenue chart: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // REFRESH DASHBOARD
  // --------------------------------------------------------------------------

  Future<void> refresh() async {
    await loadDashboard();
  }

  // --------------------------------------------------------------------------
  // CLEAR ERROR
  // --------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(error: null);
  }

  // --------------------------------------------------------------------------
  // HELPER: FORMAT DAY LABEL
  // --------------------------------------------------------------------------

  String _formatDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';

    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  // --------------------------------------------------------------------------
  // HELPER: FORMAT MONTH LABEL
  // --------------------------------------------------------------------------

  String _formatMonthLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[date.month - 1];
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================



// Dashboard State Notifier provider
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final userRepository = ref.watch(userRepositoryProvider);

  // ✅ instansiasi tanpa argumen
  final pickupRepository = PickupRepository();
  final paymentRepository = PaymentRepository();

  return DashboardNotifier(
    firestore,
    userRepository,
    pickupRepository,
    paymentRepository,
  );
});



// ============================================================================
// COMPUTED PROVIDERS (for convenience)
// ============================================================================

// Statistics
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return ref.watch(dashboardProvider).stats;
});

// Recent activities
final recentActivitiesProvider = Provider<List<RecentActivity>>((ref) {
  return ref.watch(dashboardProvider).recentActivities;
});

// Pickup trend chart
final pickupTrendProvider = Provider<List<ChartDataPoint>>((ref) {
  return ref.watch(dashboardProvider).pickupTrend;
});

// Revenue chart
final revenueChartProvider = Provider<List<ChartDataPoint>>((ref) {
  return ref.watch(dashboardProvider).revenueChart;
});

// Is loading
final dashboardLoadingProvider = Provider<bool>((ref) {
  return ref.watch(dashboardProvider).isLoading;
});

// Error message
final dashboardErrorProvider = Provider<String?>((ref) {
  return ref.watch(dashboardProvider).error;
});
