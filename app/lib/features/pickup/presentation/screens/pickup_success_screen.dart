import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/primary_button.dart';

/// Pickup success screen aligned with blueprint:
/// shows success icon, pickup code, and OTP info
class PickupSuccessScreen extends StatelessWidget {
  final String pickupId;
  final String? otp;
  final int? estimatedPoints;

  const PickupSuccessScreen({
    super.key,
    required this.pickupId,
    this.otp,
    this.estimatedPoints,
  });

  @override
  Widget build(BuildContext context) {
    final code = pickupId.isNotEmpty ? '#${pickupId.substring(0, 8)}' : '#PKP';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 96,
                  color: Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pickup Berhasil Dijadwalkan!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Kode Pickup: $code',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              if (estimatedPoints != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Estimasi poin: ~${estimatedPoints!}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xFF1E3A8A), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otp != null && otp!.isNotEmpty
                                ? 'OTP Anda: $otp'
                                : 'OTP akan dikirim via SMS',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Kurir akan menghubungi Anda saat mendekati lokasi.',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF1E40AF)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'KEMBALI KE BERANDA',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/history'),
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
                  'LIHAT DETAIL PICKUP',
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
    );
  }
}
