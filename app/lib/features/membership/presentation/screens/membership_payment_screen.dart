// ========== membership_payment_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/membership_provider.dart';

class MembershipPaymentScreen extends ConsumerWidget {
  const MembershipPaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(membershipProviderNotifier);
    final tierDetails = provider.getTierDetails(provider.selectedTier);
    final formatter = NumberFormat('#,###', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pesanan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Paket ${tierDetails['name']}'),
                        Text(
                          'Rp ${formatter.format(tierDetails['price'])}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Durasi',
                            style: TextStyle(color: Colors.grey.shade600)),
                        Text('${tierDetails['duration']} hari'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp ${formatter.format(tierDetails['price'])}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment Methods
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildPaymentMethod(
              ref,
              'bank_transfer',
              'Transfer Bank',
              Icons.account_balance,
              provider.paymentMethod == 'bank_transfer',
            ),
            _buildPaymentMethod(
              ref,
              'e_wallet',
              'E-Wallet (OVO, GoPay, Dana)',
              Icons.account_balance_wallet,
              provider.paymentMethod == 'e_wallet',
            ),
            _buildPaymentMethod(
              ref,
              'credit_card',
              'Kartu Kredit/Debit',
              Icons.credit_card,
              provider.paymentMethod == 'credit_card',
            ),

            const SizedBox(height: 32),

            // Pay Button
            ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => _processPayment(context, ref),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
              ),
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Bayar Sekarang',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),

            const SizedBox(height: 16),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Membership akan aktif setelah pembayaran dikonfirmasi (maks. 1x24 jam)',
                      style:
                          TextStyle(fontSize: 12, color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    WidgetRef ref,
    String value,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: RadioListTile<String>(
        value: value,
        groupValue: ref.watch(membershipProviderNotifier).paymentMethod,
        onChanged: (val) {
          if (val != null) {
            ref.read(membershipProviderNotifier).setPaymentMethod(val);
          }
        },
        title: Text(label),
        secondary: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
        activeColor: Colors.green,
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, WidgetRef ref) async {
    final paymentId =
        await ref.read(membershipProviderNotifier).createUpgradePayment();

    if (paymentId != null && context.mounted) {
      final tierDetails =
          ref.read(membershipProviderNotifier).getTierDetails(
                ref.read(membershipProviderNotifier).selectedTier,
              );
      final amount = tierDetails['price']?.toString() ?? '0';
      context.pushReplacement(
          '/membership/payment/waiting?paymentId=$paymentId&amount=$amount');
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuat pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
