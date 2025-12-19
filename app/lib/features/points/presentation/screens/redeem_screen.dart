// SCREEN 3: Redeem
import '../../providers/points_provider.dart';
import '../../widgets/voucher_redeem_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



class RedeemScreen extends ConsumerStatefulWidget {
  const RedeemScreen({super.key});

  @override
  ConsumerState<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends ConsumerState<RedeemScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pointsState = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('REDEEM POIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [Tab(text: 'KUPON'), Tab(text: 'SALDO')],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Poin Tersedia:', style: TextStyle(fontSize: 14)),
                Text('${pointsState.balance} poin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVoucherTab(pointsState),
                _buildBalanceTab(pointsState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherTab(PointsState pointsState) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Tukar Poin ke Kupon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...availableVouchers.map((voucher) {
          return VoucherRedeemCard(
            voucher: voucher,
            currentPoints: pointsState.balance,
            onRedeem: () => _showRedeemConfirmation(voucher),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBalanceTab(PointsState pointsState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tukar Poin ke Saldo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: _pointsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah Poin',
              suffixText: 'poin',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              final points = int.tryParse(value) ?? 0;
              ref.read(pointsProvider.notifier).setRedeemPoints(points);
            },
          ),
          const SizedBox(height: 8),
          const Text('Konversi: 100 poin = Rp 10.000', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Anda akan menerima:', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                const SizedBox(height: 4),
                Text('Rp ${_formatRupiah(pointsState.redeemAmount)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: pointsState.canRedeemToBalance ? () => _submitBalanceRedeem() : null,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            child: const Text('TUKAR POIN'),
          ),
        ],
      ),
    );
  }

  void _showRedeemConfirmation(Map<String, dynamic> voucher) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Redeem'),
        content: Text('Tukar ${voucher['points']} poin menjadi ${voucher['name']}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(pointsProvider.notifier).redeemToVoucher(voucher);
              if (success && mounted) {
                final name = voucher['name']?.toString() ?? '';
                final points = voucher['points'] as int? ?? 0;
                final value = voucher['value']?.toString() ?? '';
                context.go('/redeem/success?type=voucher&name=$name&points=$points&value=$value');
              }
            },
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitBalanceRedeem() async {
    final success = await ref.read(pointsProvider.notifier).redeemToBalance();
    if (success && mounted) {
      final points = ref.read(pointsProvider).redeemPoints;
      final value = _formatRupiah(ref.read(pointsProvider).redeemAmount);
      context.go('/redeem/success?type=balance&name=Saldo&points=$points&value=Rp$value');
    }
  }

  String _formatRupiah(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
