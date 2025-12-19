import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/membership_provider.dart';

class MembershipDetailScreen extends ConsumerWidget {
  final String planId;
  const MembershipDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(membershipProviderNotifier);
    final tier = planId.toLowerCase();
    final details = provider.getTierDetails(tier);
    final benefits = (details['benefits'] as List?)?.cast<String>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Paket ${details['name'] ?? planId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: (details['gradient'] as List?)?.cast<Color>() ??
                      [const Color(0xFF18A558), const Color(0xFF139145)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${details['badge'] ?? '👑'} ${details['name'] ?? planId}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${details['price']} / ${details['duration']} hari',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Benefit utama:',
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ...benefits
                      .map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    b,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'FAQ Singkat',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Membership aktif setelah pembayaran terkonfirmasi.\n• Dapat diperpanjang sebelum masa aktif berakhir.\n• Benefit poin & kupon otomatis diterapkan.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(membershipProviderNotifier).setSelectedTier(tier);
                context.push('/membership/payment');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                backgroundColor: const Color(0xFF18A558),
              ),
              child: const Text(
                'Pilih Paket',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
