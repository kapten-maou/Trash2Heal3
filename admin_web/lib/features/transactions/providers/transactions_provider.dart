// admin_web/lib/features/transactions/providers/transactions_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';



// ============================================================================
// TRANSACTION ITEM (Unified view of all transaction types)
// ============================================================================

class TransactionItem {
  final String id;
  final String type; // 'payment', 'redeem', 'pickup', 'points'
  final String userId;
  final String? userName;
  final double amount;
  final String status;
  final String description;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata; // Additional data

  const TransactionItem({
    required this.id,
    required this.type,
    required this.userId,
    this.userName,
    required this.amount,
    required this.status,
    required this.description,
    required this.createdAt,
    this.metadata,
  });

  TransactionItem copyWith({
    String? id,
    String? type,
    String? userId,
    String? userName,
    double? amount,
    String? status,
    String? description,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// ============================================================================
// TRANSACTIONS STATE
// ============================================================================

class TransactionsState {
  final List<TransactionItem> transactions;
  final List<TransactionItem> filteredTransactions;
  final TransactionItem? selectedTransaction;
  final bool isLoading;
  final String? error;

  // Filters
  final String?
      filterType; // 'payment', 'redeem', 'pickup', 'points', null (all)
  final String? filterStatus; // varies by type
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final String searchQuery;

  // Pagination
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;

  const TransactionsState({
    this.transactions = const [],
    this.filteredTransactions = const [],
    this.selectedTransaction,
    this.isLoading = false,
    this.error,
    this.filterType,
    this.filterStatus,
    this.filterStartDate,
    this.filterEndDate,
    this.searchQuery = '',
    this.currentPage = 1,
    this.itemsPerPage = 50,
    this.totalItems = 0,
  });

  TransactionsState copyWith({
    List<TransactionItem>? transactions,
    List<TransactionItem>? filteredTransactions,
    TransactionItem? selectedTransaction,
    bool? isLoading,
    String? error,
    String? filterType,
    String? filterStatus,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    String? searchQuery,
    int? currentPage,
    int? itemsPerPage,
    int? totalItems,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedTransaction: selectedTransaction ?? this.selectedTransaction,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterType: filterType ?? this.filterType,
      filterStatus: filterStatus ?? this.filterStatus,
      filterStartDate: filterStartDate ?? this.filterStartDate,
      filterEndDate: filterEndDate ?? this.filterEndDate,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  int get totalPages => (totalItems / itemsPerPage).ceil();

  List<TransactionItem> get paginatedTransactions {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex =
        (startIndex + itemsPerPage).clamp(0, filteredTransactions.length);

    if (startIndex >= filteredTransactions.length) {
      return [];
    }

    return filteredTransactions.sublist(startIndex, endIndex);
  }
}

// ============================================================================
// TRANSACTION TYPE CONSTANTS
// ============================================================================

class TransactionType {
  static const String payment = 'payment';
  static const String redeem = 'redeem';
  static const String pickup = 'pickup';
  static const String points = 'points';

  static const List<String> all = [payment, redeem, pickup, points];

  static String getDisplayName(String type) {
    switch (type) {
      case payment:
        return 'Payment';
      case redeem:
        return 'Redemption';
      case pickup:
        return 'Pickup';
      case points:
        return 'Points';
      default:
        return type;
    }
  }
}

// ============================================================================
// TRANSACTIONS PROVIDER
// ============================================================================

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;

  TransactionsNotifier(this._firestore, this._userRepository)
      : super(const TransactionsState());

  // --------------------------------------------------------------------------
  // LOAD ALL TRANSACTIONS
  // --------------------------------------------------------------------------

  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final allTransactions = <TransactionItem>[];

      // Load payments
      final payments = await _loadPayments();
      allTransactions.addAll(payments);

      // Load redemptions
      final redemptions = await _loadRedemptions();
      allTransactions.addAll(redemptions);

      // Load pickups
      final pickups = await _loadPickups();
      allTransactions.addAll(pickups);

      // Load point ledger
      final pointsLedger = await _loadPointsLedger();
      allTransactions.addAll(pointsLedger);

      // Sort by created date (newest first)
      allTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(
        transactions: allTransactions,
        filteredTransactions: allTransactions,
        totalItems: allTransactions.length,
        isLoading: false,
      );

      // Apply existing filters
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load transactions: $e',
      );
    }
  }

  // --------------------------------------------------------------------------
  // LOAD PAYMENTS
  // --------------------------------------------------------------------------

  Future<List<TransactionItem>> _loadPayments() async {
    try {
      final snapshot = await _firestore
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .limit(1000)
          .get();

      final transactions = <TransactionItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;

        String? userName;
        if (userId != null) {
          final user = await _userRepository.getById(userId);
          userName = user?.name;
        }

        transactions.add(TransactionItem(
          id: doc.id,
          type: TransactionType.payment,
          userId: userId ?? 'unknown',
          userName: userName,
          amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
          status: data['status'] as String? ?? 'unknown',
          description: 'Payment - ${data['method'] ?? 'Unknown method'}',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          metadata: {
            'method': data['method'],
            'paymentId': data['paymentId'],
          },
        ));
      }

      return transactions;
    } catch (e) {
      print('Error loading payments: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // LOAD REDEMPTIONS
  // --------------------------------------------------------------------------

  Future<List<TransactionItem>> _loadRedemptions() async {
    try {
      final snapshot = await _firestore
          .collection('redeem_requests')
          .orderBy('createdAt', descending: true)
          .limit(1000)
          .get();

      final transactions = <TransactionItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;

        String? userName;
        if (userId != null) {
          final user = await _userRepository.getById(userId);
          userName = user?.name;
        }

        transactions.add(TransactionItem(
          id: doc.id,
          type: TransactionType.redeem,
          userId: userId ?? 'unknown',
          userName: userName,
          amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
          status: data['status'] as String? ?? 'unknown',
          description: 'Points Redemption to ${data['type'] ?? 'Unknown'}',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          metadata: {
            'redeemType': data['type'],
            'pointsUsed': data['pointsUsed'],
          },
        ));
      }

      return transactions;
    } catch (e) {
      print('Error loading redemptions: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // LOAD PICKUPS
  // --------------------------------------------------------------------------

  Future<List<TransactionItem>> _loadPickups() async {
    try {
      final snapshot = await _firestore
          .collection('pickup_requests')
          .orderBy('createdAt', descending: true)
          .limit(1000)
          .get();

      final transactions = <TransactionItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;

        String? userName;
        if (userId != null) {
          final user = await _userRepository.getById(userId);
          userName = user?.name;
        }

        // Calculate total weight
        final wasteTypes = data['wasteTypes'] as Map<String, dynamic>? ?? {};
        var totalWeight = 0.0;
        wasteTypes.forEach((key, value) {
          totalWeight += (value as num?)?.toDouble() ?? 0.0;
        });

        transactions.add(TransactionItem(
          id: doc.id,
          type: TransactionType.pickup,
          userId: userId ?? 'unknown',
          userName: userName,
          amount: totalWeight,
          status: data['status'] as String? ?? 'unknown',
          description: 'Pickup Request - ${totalWeight.toStringAsFixed(2)} kg',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          metadata: {
            'wasteTypes': wasteTypes,
            'pointsEarned': data['pointsEarned'],
            'slotId': data['slotId'],
          },
        ));
      }

      return transactions;
    } catch (e) {
      print('Error loading pickups: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // LOAD POINTS LEDGER
  // --------------------------------------------------------------------------

  Future<List<TransactionItem>> _loadPointsLedger() async {
    try {
      final snapshot = await _firestore
          .collection('point_ledger')
          .orderBy('createdAt', descending: true)
          .limit(1000)
          .get();

      final transactions = <TransactionItem>[];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userId = data['userId'] as String?;

        String? userName;
        if (userId != null) {
          final user = await _userRepository.getById(userId);
          userName = user?.name;
        }

        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final type = data['type'] as String? ?? 'unknown';
        final source = data['source'] as String? ?? 'unknown';

        transactions.add(TransactionItem(
          id: doc.id,
          type: TransactionType.points,
          userId: userId ?? 'unknown',
          userName: userName,
          amount: amount.abs(),
          status: type, // 'earned' or 'spent'
          description:
              'Points ${type.toUpperCase()} - ${data['description'] ?? source}',
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          metadata: {
            'source': source,
            'ledgerType': type,
          },
        ));
      }

      return transactions;
    } catch (e) {
      print('Error loading points ledger: $e');
      return [];
    }
  }

  // --------------------------------------------------------------------------
  // GET TRANSACTION STATISTICS
  // --------------------------------------------------------------------------

  Future<Map<String, dynamic>> getTransactionStatistics() async {
    try {
      final transactions = state.filteredTransactions;

      // Total amounts by type
      final paymentTotal = transactions
          .where((t) =>
              t.type == TransactionType.payment && t.status == 'completed')
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final redeemTotal = transactions
          .where((t) =>
              t.type == TransactionType.redeem && t.status == 'completed')
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final pickupTotal = transactions
          .where((t) =>
              t.type == TransactionType.pickup && t.status == 'completed')
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final pointsEarned = transactions
          .where(
              (t) => t.type == TransactionType.points && t.status == 'earned')
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      final pointsSpent = transactions
          .where((t) => t.type == TransactionType.points && t.status == 'spent')
          .fold<double>(0.0, (sum, t) => sum + t.amount);

      // Count by status
      final pending = transactions.where((t) => t.status == 'pending').length;
      final completed =
          transactions.where((t) => t.status == 'completed').length;
      final failed = transactions
          .where((t) => t.status == 'failed' || t.status == 'rejected')
          .length;

      return {
        'paymentTotal': paymentTotal,
        'redeemTotal': redeemTotal,
        'pickupTotal': pickupTotal,
        'pointsEarned': pointsEarned,
        'pointsSpent': pointsSpent,
        'pendingCount': pending,
        'completedCount': completed,
        'failedCount': failed,
        'totalTransactions': transactions.length,
      };
    } catch (e) {
      print('Error getting transaction statistics: $e');
      return {};
    }
  }

  // --------------------------------------------------------------------------
  // EXPORT TRANSACTIONS (Prepare data for CSV export)
  // --------------------------------------------------------------------------

  List<Map<String, dynamic>> exportTransactions() {
    return state.filteredTransactions.map((t) {
      return {
        'ID': t.id,
        'Type': TransactionType.getDisplayName(t.type),
        'User ID': t.userId,
        'User Name': t.userName ?? 'Unknown',
        'Amount': t.amount,
        'Status': t.status,
        'Description': t.description,
        'Date': t.createdAt.toIso8601String(),
      };
    }).toList();
  }

  // --------------------------------------------------------------------------
  // FILTERS
  // --------------------------------------------------------------------------

  void setTypeFilter(String? type) {
    state = state.copyWith(filterType: type, currentPage: 1);
    _applyFilters();
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(filterStatus: status, currentPage: 1);
    _applyFilters();
  }

  void setDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      filterStartDate: startDate,
      filterEndDate: endDate,
      currentPage: 1,
    );
    _applyFilters();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _applyFilters();
  }

  void clearFilters() {
    state = state.copyWith(
      filterType: null,
      filterStatus: null,
      filterStartDate: null,
      filterEndDate: null,
      searchQuery: '',
      filteredTransactions: state.transactions,
      currentPage: 1,
    );
    _updateTotalItems();
  }

  void _applyFilters() {
    var filtered = state.transactions;

    // Filter by type
    if (state.filterType != null) {
      filtered = filtered.where((t) => t.type == state.filterType).toList();
    }

    // Filter by status
    if (state.filterStatus != null) {
      filtered = filtered.where((t) => t.status == state.filterStatus).toList();
    }

    // Filter by date range
    if (state.filterStartDate != null) {
      filtered = filtered.where((t) {
        return !t.createdAt.isBefore(state.filterStartDate!);
      }).toList();
    }

    if (state.filterEndDate != null) {
      // Set end of day for end date
      final endOfDay = DateTime(
        state.filterEndDate!.year,
        state.filterEndDate!.month,
        state.filterEndDate!.day,
        23,
        59,
        59,
      );

      filtered = filtered.where((t) {
        return !t.createdAt.isAfter(endOfDay);
      }).toList();
    }

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return t.id.toLowerCase().contains(query) ||
            (t.userName?.toLowerCase().contains(query) ?? false) ||
            t.userId.toLowerCase().contains(query) ||
            t.description.toLowerCase().contains(query);
      }).toList();
    }

    state = state.copyWith(filteredTransactions: filtered);
    _updateTotalItems();
  }

  void _updateTotalItems() {
    state = state.copyWith(totalItems: state.filteredTransactions.length);
  }

  // --------------------------------------------------------------------------
  // PAGINATION
  // --------------------------------------------------------------------------

  void setPage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      state = state.copyWith(currentPage: page);
    }
  }

  void nextPage() {
    if (state.currentPage < state.totalPages) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 1) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void setItemsPerPage(int items) {
    state = state.copyWith(itemsPerPage: items, currentPage: 1);
  }

  // --------------------------------------------------------------------------
  // CLEAR ERROR
  // --------------------------------------------------------------------------

  void clearError() {
    state = state.copyWith(error: null);
  }

  // --------------------------------------------------------------------------
  // SELECT TRANSACTION
  // --------------------------------------------------------------------------

  void selectTransaction(TransactionItem transaction) {
    state = state.copyWith(selectedTransaction: transaction);
  }

  void clearSelectedTransaction() {
    state = state.copyWith(selectedTransaction: null);
  }

  // --------------------------------------------------------------------------
  // REFRESH
  // --------------------------------------------------------------------------

  Future<void> refresh() async {
    await loadTransactions();
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// User Repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Transactions State Notifier provider
final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  return TransactionsNotifier(firestore, userRepository);
});

// ============================================================================
// COMPUTED PROVIDERS (for convenience)
// ============================================================================

// All transactions
final allTransactionsProvider = Provider<List<TransactionItem>>((ref) {
  return ref.watch(transactionsProvider).transactions;
});

// Filtered transactions
final filteredTransactionsProvider = Provider<List<TransactionItem>>((ref) {
  return ref.watch(transactionsProvider).filteredTransactions;
});

// Paginated transactions
final paginatedTransactionsProvider = Provider<List<TransactionItem>>((ref) {
  return ref.watch(transactionsProvider).paginatedTransactions;
});

// Selected transaction
final selectedTransactionProvider = Provider<TransactionItem?>((ref) {
  return ref.watch(transactionsProvider).selectedTransaction;
});

// Is loading
final transactionsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(transactionsProvider).isLoading;
});

// Error message
final transactionsErrorProvider = Provider<String?>((ref) {
  return ref.watch(transactionsProvider).error;
});

// Pagination info
final transactionsPaginationProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(transactionsProvider);
  return {
    'currentPage': state.currentPage,
    'totalPages': state.totalPages,
    'totalItems': state.totalItems,
    'itemsPerPage': state.itemsPerPage,
  };
});

// Transactions by type
final transactionsByTypeProvider =
    Provider<Map<String, List<TransactionItem>>>((ref) {
  final transactions = ref.watch(transactionsProvider).filteredTransactions;
  final grouped = <String, List<TransactionItem>>{};

  for (final transaction in transactions) {
    if (!grouped.containsKey(transaction.type)) {
      grouped[transaction.type] = [];
    }
    grouped[transaction.type]!.add(transaction);
  }

  return grouped;
});
