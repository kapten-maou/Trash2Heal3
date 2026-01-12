import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pickup_provider.dart';
import '../../widgets/stepper_indicator.dart';
import '../../widgets/category_counter_card.dart';
import '../../../../common/widgets/primary_button.dart';

class PickupQuantityScreen extends ConsumerWidget {
  const PickupQuantityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickupState = ref.watch(pickupProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            _showExitDialog(context, ref);
          },
        ),
        title: const Text(
          'PICKUP',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stepper
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const StepperIndicator(currentStep: 1, totalSteps: 4),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Kategori & Jumlah Sampah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category cards
                  ...wasteCategories.map((category) {
                    final categoryId = category['id'] as String;
                    final quantity = pickupState.quantities[categoryId] ?? 0.0;

                    return CategoryCounterCard(
                      categoryId: categoryId,
                      name: category['name'] as String,
                      icon: category['icon'] as String,
                      imageUrl: category['imageUrl'] as String?,
                      value: quantity,
                      onChanged: (value) {
                        ref.read(pickupProvider.notifier).updateQuantity(
                              categoryId,
                              value,
                            );
                      },
                      onIncrement: () {
                        ref
                            .read(pickupProvider.notifier)
                            .incrementQuantity(categoryId);
                      },
                      onDecrement: () {
                        ref
                            .read(pickupProvider.notifier)
                            .decrementQuantity(categoryId);
                      },
                    );
                  }).toList(),

                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          ),

          // Bottom estimation + button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Estimation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Berat',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '${pickupState.totalWeight.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Estimasi Poin',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '~${pickupState.estimatedPoints} poin',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Next button
                  PrimaryButton(
                    text: 'LANJUT',
                    onPressed: pickupState.canProceedFromStep1
                        ? () {
                            ref.read(pickupProvider.notifier).nextStep();
                            context.push('/pickup/address');
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pickup?'),
        content: const Text(
          'Data yang sudah diisi akan hilang. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(pickupProvider.notifier).reset();
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
