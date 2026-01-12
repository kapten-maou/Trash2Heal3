// SCREEN 2: Points History


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_app/core/constants/app_images.dart';

import '../../providers/points_provider.dart';

import '../../widgets/transaction_list_item.dart';

class PointsHistoryScreen extends ConsumerWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsState = ref.watch(pointsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('RIWAYAT POIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: pointsState.transactions.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat',
                  style: TextStyle(color: Color(0xFF6B7280))))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pointsState.transactions.length,
              itemBuilder: (context, index) {
                return TransactionListItem(
                    transaction: pointsState.transactions[index]);
              },
            ),
    );
  }
}
