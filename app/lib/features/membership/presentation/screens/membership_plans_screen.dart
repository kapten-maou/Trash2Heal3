// ========== membership_plans_screen.dart ==========
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/membership_provider.dart';

class MembershipPlansScreen extends ConsumerWidget {
  const MembershipPlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(membershipProviderNotifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Membership'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade500],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Status Saat Ini',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.currentMembership?.tier.name.toUpperCase() ?? 'SILVER',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (provider.currentMembership != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Berlaku hingga ${DateFormat('dd MMM yyyy').format(provider.currentMembership!.endDate)}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Pilih Paket Membership',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Silver Plan
            _buildPlanCard(
              context,
              ref,
              'silver',
              provider.selectedTier == 'silver',
            ),
            const SizedBox(height: 12),

            // Gold Plan
            _buildPlanCard(
              context,
              ref,
              'gold',
              provider.selectedTier == 'gold',
            ),

            const SizedBox(height: 12),

            // Platinum Plan
            _buildPlanCard(
              context,
              ref,
              'platinum',
              provider.selectedTier == 'platinum',
            ),

            const SizedBox(height: 32),

            // Continue Button
            ElevatedButton(
              onPressed: () => context.push('/membership/payment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Lanjut ke Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      BuildContext context, WidgetRef ref, String tier, bool isSelected) {
    final provider = ref.read(membershipProviderNotifier);
    final details = provider.getTierDetails(tier);
    final formatter = NumberFormat('#,###', 'id_ID');

    final gradient = (details['gradient'] as List<Color>?);

    return Card(
      elevation: isSelected ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => ref.read(membershipProviderNotifier).setSelectedTier(tier),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: gradient != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  )
                : null,
            color: gradient == null ? Colors.white : null,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    details['badge']?.toString() ?? '👑',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${details['duration']} hari',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Rp ${formatter.format(details['price'])}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Keuntungan:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              ...(details['benefits'] as List).map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                          benefit,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
