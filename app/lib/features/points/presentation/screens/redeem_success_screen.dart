import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';
import '../../../../common/widgets/primary_button.dart';

class RedeemSuccessScreen extends StatelessWidget {
  final String type; // voucher or balance
  final String name;
  final int points;
  final String value;

  const RedeemSuccessScreen({
    super.key,
    required this.type,
    required this.name,
    required this.points,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isBalance = type == 'balance';
    final title = isBalance ? 'Redeem ke Saldo Berhasil!' : 'Kupon Berhasil Dibuat!';
    final subtitle =
        isBalance ? 'Dana akan diproses dalam 1-3 hari kerja' : 'Gunakan kupon sebelum masa berlaku habis.';

    return Scaffold(
      backgroundColor: Colors.white,
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle,
                      size: 80, color: Color(0xFF10B981)),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isNotEmpty ? name : (isBalance ? 'Redeem Saldo' : 'Kupon'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isBalance ? 'Nilai: $value' : 'Nilai Kupon: $value',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Poin terpakai: $points',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: 'KEMBALI',
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go('/points'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'LIHAT POIN & VOUCHER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
