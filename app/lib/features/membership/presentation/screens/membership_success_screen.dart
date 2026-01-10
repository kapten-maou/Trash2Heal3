import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';

class MembershipSuccessScreen extends StatefulWidget {
  final String paymentId;

  const MembershipSuccessScreen({super.key, required this.paymentId});

  @override
  State<MembershipSuccessScreen> createState() =>
      _MembershipSuccessScreenState();
}

class _MembershipSuccessScreenState extends State<MembershipSuccessScreen> {
  final _paymentRepo = PaymentRepository();
  final _membershipRepo = MembershipRepository();
  PaymentModel? _payment;
  MembershipModel? _membership;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final payment = await _paymentRepo.getPaymentById(widget.paymentId);
      MembershipModel? membership;
      if (payment?.userId != null) {
        membership =
            await _membershipRepo.getActiveMembershipByUser(payment!.userId);
      }
      setState(() {
        _payment = payment;
        _membership = membership;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'id_ID');
    final tier = _membership?.tier.name.toUpperCase() ??
        _payment?.itemDetails?['tier']?.toString().toUpperCase() ??
        'MEMBER';
    final expiry = _membership?.endDate;
    final amount = _payment?.totalAmount;
    final invoice = _payment?.invoiceNumber ?? _payment?.orderId ?? '-';
    final method = _payment?.method.name.toUpperCase() ?? 'METODE';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(AppImages.successConfetti),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.82),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 80,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Pembayaran Berhasil!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Membership $tier aktif.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (expiry != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Berlaku hingga ${_formatDate(expiry)}',
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF6B7280)),
                        ),
                      ],
                      const SizedBox(height: 20),
                      _InfoCard(
                        items: [
                          _InfoRow(label: 'Invoice', value: invoice),
                          _InfoRow(label: 'Metode', value: method),
                          if (amount != null)
                            _InfoRow(
                              label: 'Total bayar',
                              value: 'Rp ${formatter.format(amount)}',
                            ),
                          if (_membership?.startDate != null)
                            _InfoRow(
                              label: 'Aktif sejak',
                              value: _formatDate(_membership!.startDate),
                            ),
                        ],
                      ),
                      if (amount != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.info_outline,
                                  size: 20, color: Color(0xFF6B7280)),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Benefit membership sudah aktif. Tagihan tersimpan di riwayat pembayaran.',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF6B7280)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 36),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => context.go('/membership/plans'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                side: const BorderSide(color: Color(0xFF18A558)),
                              ),
                              child: const Text(
                                'Lihat Benefit',
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF18A558)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.go('/home'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                backgroundColor: const Color(0xFF18A558),
                              ),
                              child: const Text(
                                'Kembali ke Home',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1)
              const Divider(height: 20, color: Color(0xFFE5E7EB)),
          ]
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w600),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontSize: 14, color: Color(0xFF111827), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
