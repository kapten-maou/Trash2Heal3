import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pickup_provider.dart';
import '../../widgets/stepper_indicator.dart';
import '../../../../common/widgets/primary_button.dart';
import '../../../../common/widgets/loading_overlay.dart';

class PickupReviewScreen extends ConsumerWidget {
  const PickupReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);

    return LoadingOverlay(
      isLoading: pickupState.isLoading,
      message: 'Membuat pickup...',
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.read(pickupProvider.notifier).previousStep();
              context.pop();
            },
          ),
          title: const Text('PICKUP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: const StepperIndicator(currentStep: 4, totalSteps: 4),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Penjemputan',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 16),

                    // Waste details
                    _buildSectionCard(
                      title: 'Detail Sampah',
                      child: Column(
                        children: [
                          ...pickupState.quantities.entries.map((entry) {
                            final category = wasteCategories
                                .firstWhere((c) => c['id'] == entry.key);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '${category['icon']} ${category['name']}',
                                      style: const TextStyle(fontSize: 14)),
                                  Text('${entry.value.toStringAsFixed(1)} kg',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            );
                          }).toList(),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${pickupState.totalWeight.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Address
                    if (pickupState.selectedAddress != null)
                      _buildSectionCard(
                        title: 'Alamat Penjemputan',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pickupState.selectedAddress!.label,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(pickupState.selectedAddress!.fullAddress,
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF6B7280))),
                            Text(
                                '${pickupState.selectedAddress!.city}, ${pickupState.selectedAddress!.postalCode}',
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF6B7280))),
                            const SizedBox(height: 4),
                            Text(pickupState.selectedAddress!.phone,
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),

                    // Schedule
                    if (pickupState.selectedSlot != null &&
                        pickupState.selectedDate != null)
                      _buildSectionCard(
                        title: 'Jadwal',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_formatDate(pickupState.selectedDate!),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(pickupState.selectedSlot!.timeRange,
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF6B7280))),
                            Text('Zona ${pickupState.selectedSlot!.zone}',
                                style: const TextStyle(
                                    fontSize: 14, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),

                    // Estimated points
                    _buildSectionCard(
                      title: 'Estimasi Poin',
                      backgroundColor: const Color(0xFFFEF3C7),
                      child: Column(
                        children: [
                          Text('~${pickupState.estimatedPoints} poin',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.info_outline,
                                  size: 16, color: Color(0xFF92400E)),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                    'Poin final bergantung pada berat aktual',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF92400E))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Important notes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Color(0xFF1E40AF), size: 20),
                              SizedBox(width: 8),
                              Text('Catatan Penting:',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E40AF))),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('• Pastikan sampah sudah dipilah',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF1E3A8A))),
                          Text('• Kurir akan menimbang ulang',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF1E3A8A))),
                          Text('• Kode OTP akan dikirim via SMS',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF1E3A8A))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2))
                ],
              ),
              child: SafeArea(
                top: false,
                child: PrimaryButton(
                  text: 'KONFIRMASI PICKUP',
                  onPressed: () async {
                    final result =
                        await ref.read(pickupProvider.notifier).submitPickup();

                    if (!context.mounted) return;

                    if (result != null) {
                      context.push(
                        '/pickup/success',
                        extra: {
                          'pickupId': result.id,
                          'otp': result.otp,
                          'points': pickupState.estimatedPoints,
                        },
                      );
                    } else {
                      final error =
                          ref.read(pickupProvider).errorMessage ??
                              'Pickup tidak bisa dikonfirmasi. Coba lagi.';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required Widget child, Color? backgroundColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// SUCCESS SCREEN (moved to pickup_success_screen.dart)
