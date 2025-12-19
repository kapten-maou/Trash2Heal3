// SCREEN 1: Points Detail
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/points_provider.dart';
import '../../widgets/my_voucher_card.dart';
import '../../widgets/transaction_list_item.dart';

class PointsScreen extends ConsumerStatefulWidget {
  const PointsScreen({super.key});

  @override
  ConsumerState<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends ConsumerState<PointsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(pointsProvider.notifier).loadPointsData());
  }

  @override
  Widget build(BuildContext context) {
    final pointsState = ref.watch(pointsProvider);
    final totalVoucherValue = pointsState.vouchers.fold<int>(
        0, (sum, v) => sum + (v.value ?? 0));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('POIN SAYA',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(pointsProvider.notifier).loadPointsData(),
        child: pointsState.isLoading
            ? const _PointsSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDCFCE7)),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF18A558),
                            child: Icon(Icons.card_giftcard,
                                color: Colors.white, size: 18),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tukar poinmu jadi voucher atau saldo. Jangan biarkan poin hangus!',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF065F46)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Points Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            top: -10,
                            child: Opacity(
                              opacity: 0.2,
                              child: Icon(Icons.card_giftcard,
                                  size: 120, color: Colors.white),
                            ),
                          ),
                          Column(
                            children: [
                              const Icon(Icons.stars,
                                  color: Colors.white, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                '${pointsState.balance}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text('POIN',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      letterSpacing: 2)),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => context.push('/redeem'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFFF59E0B),
                                      ),
                                      child: const Text('Redeem Poin'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          context.push('/points/history'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFFF59E0B),
                                      ),
                                      child: const Text('Riwayat'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Voucher & FAQ summary
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            title: 'Kupon Aktif',
                            value:
                                '${pointsState.vouchers.length} kupon',
                            subtitle:
                                'Total Rp $totalVoucherValue',
                            icon: Icons.confirmation_num_outlined,
                            onTap: () => context.push('/redeem'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            title: 'FAQ Member',
                            value: 'Benefit & syarat',
                            subtitle: 'Lihat paket member',
                            icon: Icons.help_outline,
                            onTap: () => context.push('/membership/plans'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Vouchers
                    if (pointsState.vouchers.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kupon Aktif',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => context.push('/points/history'),
                            child: const Text('Lihat Semua'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...pointsState.vouchers
                          .take(2)
                          .map((v) => MyVoucherCard(voucher: v))
                          .toList(),
                      const SizedBox(height: 24),
                    ],

                    // Recent Transactions
                    const Text('Riwayat Poin Terakhir',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (pointsState.transactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Belum ada riwayat',
                              style: TextStyle(color: Color(0xFF6B7280))),
                        ),
                      )
                    else
                      ...pointsState.transactions
                          .take(5)
                          .map((t) => TransactionListItem(transaction: t))
                          .toList(),

                    if (pointsState.transactions.length > 5)
                      Center(
                        child: TextButton(
                          onPressed: () => context.push('/points/history'),
                          child: const Text('Lihat Semua Riwayat'),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF18A558)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF18A558)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _PointsSkeleton extends StatelessWidget {
  const _PointsSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget bar({double height = 12, double width = 80}) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE68A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                bar(height: 48, width: 120),
                const SizedBox(height: 12),
                bar(width: 60),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: bar(height: 40, width: double.infinity)),
                    const SizedBox(width: 12),
                    Expanded(child: bar(height: 40, width: double.infinity)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: bar(height: 100, width: double.infinity)),
              const SizedBox(width: 12),
              Expanded(child: bar(height: 100, width: double.infinity)),
            ],
          ),
          const SizedBox(height: 24),
          bar(width: 140),
          const SizedBox(height: 12),
          bar(width: double.infinity, height: 56),
          const SizedBox(height: 8),
          bar(width: double.infinity, height: 56),
        ],
      ),
    );
  }
}
