import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../auth/providers/auth_provider.dart';

/// Available vouchers for redemption
const availableVouchers = [
  {
    'id': 'voucher_10k',
    'name': 'Kupon Rp 10.000',
    'points': 100,
    'value': 10000
  },
  {
    'id': 'voucher_25k',
    'name': 'Kupon Rp 25.000',
    'points': 250,
    'value': 25000
  },
  {
    'id': 'voucher_50k',
    'name': 'Kupon Rp 50.000',
    'points': 500,
    'value': 50000,
    'discount': '10%'
  },
  {
    'id': 'voucher_100k',
    'name': 'Kupon Rp 100.000',
    'points': 1000,
    'value': 100000,
    'discount': '15%'
  },
];

/// Points state
class PointsState {
  final int balance;
  final List<PointLedgerModel> transactions;
  final List<CouponModel> vouchers;
  final bool isLoading;
  final String? errorMessage;

  // Redemption state
  final int redeemPoints;
  final String? selectedBankAccount;

  const PointsState({
    this.balance = 0,
    this.transactions = const [],
    this.vouchers = const [],
    this.isLoading = false,
    this.errorMessage,
    this.redeemPoints = 0,
    this.selectedBankAccount,
  });

  // Computed properties
  int get redeemAmount =>
      (redeemPoints / 10).round() * 1000; // 100 poin = Rp 10.000
  bool get canRedeemToBalance => redeemPoints >= 100 && redeemPoints <= balance;

  PointsState copyWith({
    int? balance,
    List<PointLedgerModel>? transactions,
    List<CouponModel>? vouchers,
    bool? isLoading,
    String? errorMessage,
    int? redeemPoints,
    String? selectedBankAccount,
  }) {
    return PointsState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      vouchers: vouchers ?? this.vouchers,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      redeemPoints: redeemPoints ?? this.redeemPoints,
      selectedBankAccount: selectedBankAccount ?? this.selectedBankAccount,
    );
  }
}

/// Points notifier
class PointsNotifier extends StateNotifier<PointsState> {
  final Ref _ref;
  final PointLedgerRepository _ledgerRepository;
  final CouponRepository _couponRepository;
  final RedeemRequestRepository _redeemRepository;
  final UserRepository _userRepository;

  PointsNotifier(this._ref)
      : _ledgerRepository = PointLedgerRepository(),
        _couponRepository = CouponRepository(),
        _redeemRepository = RedeemRequestRepository(),
        _userRepository = UserRepository(),
        super(const PointsState()) {
    _init();
  }

  Future<void> _init() async {
    final authState = _ref.read(authProvider);
    if (authState.isAuthenticated) {
      await loadPointsData();
    }
  }

  /// Load all points data
  Future<void> loadPointsData() async {
    state = state.copyWith(isLoading: true);

    try {
      final authState = _ref.read(authProvider);
      if (authState.user == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final userId = authState.user!.uid;

      final user =
          await _userRepository.getById(userId) ?? authState.user!;
      final transactions =
          await _ledgerRepository.getUserLedger(userId, limit: 50);

      // Filter out any malformed coupon documents to avoid crashes
      List<CouponModel> vouchers = [];
      try {
        vouchers = await _couponRepository.getActiveCoupons(userId);
      } catch (_) {
        vouchers = [];
      }

      state = state.copyWith(
        balance: user.pointBalance,
        transactions: transactions,
        vouchers: vouchers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Redeem points to voucher
  Future<bool> redeemToVoucher(Map<String, dynamic> voucherData) async {
    final pointsRequired = voucherData['points'] as int;

    if (state.balance < pointsRequired) {
      state = state.copyWith(errorMessage: 'Poin tidak mencukupi');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user == null) throw 'User not authenticated';

      // Create redeem request snapshot
      final redeemRequestId = await _redeemRepository.createVoucherRedemption(
        userId: user.uid,
        userName: user.name,
        userEmail: user.email,
        userPhone: user.phone,
        points: pointsRequired,
        voucherName: voucherData['name'] as String,
        voucherProvider:
            (voucherData['provider'] ?? 'Voucher') as String,
        voucherCategory:
            (voucherData['category'] ?? 'Rewards') as String,
        voucherValue: voucherData['value'] as int,
      );

      // Create coupon with the shared repository to match shared model
      final couponId = await _couponRepository.createCouponFromRedemption(
        userId: user.uid,
        redeemRequestId: redeemRequestId,
        type: CouponType.voucher,
        name: voucherData['name'] as String,
        value: voucherData['value'] as int,
        pointsSpent: pointsRequired,
        provider: voucherData['provider'] as String?,
        category: voucherData['category'] as String?,
        expiryDate: DateTime.now().add(const Duration(days: 90)),
      );

      // Deduct points & record ledger
      final newBalance = state.balance - pointsRequired;
      await _userRepository.updatePointBalance(user.uid, newBalance);
      await _ledgerRepository.recordRedeem(
        userId: user.uid,
        amount: pointsRequired,
        description: 'Redeem ${voucherData['name']}',
        relatedId: couponId,
        relatedCollection: 'coupons',
      );

      await loadPointsData();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Redeem points to balance
  Future<bool> redeemToBalance() async {
    if (!state.canRedeemToBalance) {
      state = state.copyWith(errorMessage: 'Jumlah poin tidak valid');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user == null) throw 'User not authenticated';
      if (state.selectedBankAccount == null ||
          state.selectedBankAccount!.isEmpty) {
        throw 'Pilih rekening tujuan terlebih dahulu';
      }

      final accountParts = state.selectedBankAccount!.split('-');
      final bankName = accountParts.isNotEmpty ? accountParts.first.trim() : '';
      final accountNumber =
          accountParts.length > 1 ? accountParts[1].trim() : '';

      final redeemRequestId =
          await _redeemRepository.createBalanceRedemption(
        userId: user.uid,
        userName: user.name,
        userEmail: user.email,
        userPhone: user.phone,
        points: state.redeemPoints,
        amount: state.redeemAmount,
        bankName: bankName.isEmpty ? 'Bank' : bankName,
        accountNumber: accountNumber.isEmpty
            ? state.selectedBankAccount!
            : accountNumber,
        accountHolderName: user.name,
      );

      final newBalance = state.balance - state.redeemPoints;
      await _userRepository.updatePointBalance(user.uid, newBalance);
      await _ledgerRepository.recordRedeem(
        userId: user.uid,
        amount: state.redeemPoints,
        description:
            'Redeem to Balance Rp ${_formatRupiah(state.redeemAmount)}',
        relatedId: redeemRequestId,
        relatedCollection: 'redeemRequests',
      );

      await loadPointsData();
      state = state.copyWith(
        isLoading: false,
        redeemPoints: 0,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  // Helper methods
  void setRedeemPoints(int points) {
    state = state.copyWith(redeemPoints: points);
  }

  void selectBankAccount(String account) {
    state = state.copyWith(selectedBankAccount: account);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

/// Provider
final pointsProvider =
    StateNotifierProvider<PointsNotifier, PointsState>((ref) {
  return PointsNotifier(ref);
});
