// SCREEN 3: Success

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/primary_button.dart';

class CourierSuccessScreen extends StatelessWidget {
  final String taskId;
  final double? weight;
  final int? points;

  const CourierSuccessScreen({
    super.key,
    required this.taskId,
    this.weight,
    this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    shape: BoxShape.circle),
                child: const Icon(Icons.check_circle,
                    size: 80, color: Color(0xFF10B981)),
              ),
              const SizedBox(height: 24),
              const Text('Setoran Berhasil Dikonfirmasi!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              if (weight != null || points != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      if (weight != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Berat Aktual',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827))),
                            Text(
                              '${weight!.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827)),
                            ),
                          ],
                        ),
                      if (points != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Poin untuk customer',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF111827))),
                            Text(
                              '$points poin',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                '#${taskId.substring(0, taskId.length > 8 ? 8 : taskId.length).toUpperCase()}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              PrimaryButton(
                  text: 'KEMBALI KE DAFTAR TUGAS',
                  onPressed: () => context.go('/courier/tasks')),
            ],
          ),
        ),
      ),
    );
  }
}
