// ========== membership_provider.dart ==========
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class MembershipProviderNotifier extends ChangeNotifier {
  final MembershipRepository _memberRepo;
  final PaymentRepository _paymentRepo;

  MembershipProviderNotifier(this._memberRepo, this._paymentRepo);

  MembershipModel? _currentMembership;
  String _selectedTier = 'gold';
  String _paymentMethod = 'bank_transfer';
  bool _isLoading = false;
  String? _error;

  MembershipModel? get currentMembership => _currentMembership;
  String get selectedTier => _selectedTier;
  String get paymentMethod => _paymentMethod;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedTier(String tier) {
    _selectedTier = tier;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Map<String, dynamic> getTierDetails(String tier) {
    switch (tier) {
      case 'silver':
        return {
          'name': 'Silver',
          'price': 50000,
          'duration': 30,
          'benefits': [
            'Point multiplier 1.2x',
            'Pickup prioritas',
            '1 kupon gratis'
          ],
          'color': Colors.grey,
          'gradient': [const Color(0xFF9CA3AF), const Color(0xFF6B7280)],
          'badge': '👑',
        };
      case 'gold':
        return {
          'name': 'Gold',
          'price': 99000,
          'duration': 30,
          'benefits': [
            'Point multiplier 1.5x',
            'Priority pickup',
            'Exclusive vouchers',
            'Free delivery',
          ],
          'color': const Color.fromARGB(255, 255, 215, 0),
          'gradient': [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
          'badge': '💎',
        };
      case 'platinum':
        return {
          'name': 'Platinum',
          'price': 249000,
          'duration': 90,
          'benefits': [
            'Point multiplier 2x',
            'VIP priority pickup',
            'Premium vouchers',
            'Free delivery',
            'Personal consultant',
            'Monthly report',
          ],
          'color': const Color.fromARGB(255, 229, 228, 226),
          'gradient': [const Color(0xFF7C3AED), const Color(0xFF2563EB)],
          'badge': '🏆',
        };
      default:
        return {
          'name': 'Silver',
          'price': 0,
          'duration': 0,
          'benefits': ['Basic features'],
          'color': Colors.grey,
          'gradient': [Colors.grey, Colors.grey.shade600],
          'badge': '👑',
        };
    }
  }

  Future<void> loadCurrentMembership() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final membership = await _memberRepo.getActiveMembershipByUser(uid);
      if (membership != null) {
        _currentMembership = membership;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> createUpgradePayment() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tierDetails = getTierDetails(_selectedTier);
      final now = DateTime.now();
      final generatedCode = 'T2H-${now.millisecondsSinceEpoch}';
      final method = () {
        switch (_paymentMethod) {
          case 'e_wallet':
            return PaymentMethod.ewallet;
          case 'credit_card':
            return PaymentMethod.creditCard;
          case 'qris':
            return PaymentMethod.qris;
          case 'virtual_account':
            return PaymentMethod.virtualAccount;
          default:
            return PaymentMethod.bankTransfer;
        }
      }();

      final payment = PaymentModel(
        id: '',
        userId: uid,
        userName: '',
        userEmail: '',
        type: PaymentType.membership,
        method: method,
        status: PaymentStatus.pending,
        amount: tierDetails['price'] as int,
        totalAmount: tierDetails['price'] as int,
        vaNumber: method == PaymentMethod.bankTransfer ||
                method == PaymentMethod.virtualAccount
            ? '8808${generatedCode.substring(generatedCode.length - 6)}'
            : null,
        qrCode: method == PaymentMethod.qris || method == PaymentMethod.ewallet
            ? generatedCode
            : null,
        itemDetails: {
          'tier': _selectedTier,
          'duration': tierDetails['duration'],
        },
        createdAt: now,
      );

      final paymentId = await _paymentRepo.createPayment(payment);

      _isLoading = false;
      notifyListeners();
      return paymentId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> activateMembership(String paymentId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    try {
      final tierDetails = getTierDetails(_selectedTier);
      final now = DateTime.now();
      final endDate = now.add(Duration(days: tierDetails['duration'] as int));
      final tier = _selectedTier.toLowerCase() == 'platinum'
          ? MembershipTier.platinum
          : MembershipTier.gold;

      final membership = MembershipModel(
        id: '',
        userId: uid,
        userName: '',
        userEmail: '',
        tier: tier,
        status: MembershipStatus.active,
        startDate: now,
        endDate: endDate,
        durationMonths: (tierDetails['duration'] as int) ~/ 30,
        price: tierDetails['price'] as int,
        paymentId: paymentId,
        benefits: MembershipBenefits.forTier(tier),
        createdAt: now,
        updatedAt: now,
      );

      await _memberRepo.createMembership(membership);

      // Update payment status
      await _paymentRepo.changePaymentStatus(paymentId, PaymentStatus.paid);

      await loadCurrentMembership();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

final membershipProviderNotifier =
    ChangeNotifierProvider<MembershipProviderNotifier>((ref) {
  return MembershipProviderNotifier(
      MembershipRepository(), PaymentRepository());
});
