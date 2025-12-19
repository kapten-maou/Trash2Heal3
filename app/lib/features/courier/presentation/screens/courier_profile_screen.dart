import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../providers/courier_provider.dart';
import '../../../auth/providers/auth_provider.dart';

class CourierProfileScreen extends ConsumerWidget {
  const CourierProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courierState = ref.watch(courierProvider);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Kurir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green.shade100,
              child: Text(
                user?.name.isNotEmpty == true
                    ? user!.name[0].toUpperCase()
                    : 'K',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F7A38)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'Kurir',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827)),
            ),
            Text(
              user?.phone ?? '',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _ProfileStat(
                  label: 'Tugas Hari Ini',
                  value: courierState.todayTasks.length,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _ProfileStat(
                  label: 'Selesai',
                  value: courierState.completedTasks.length,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                title: const Text('Keluar'),
                onTap: () => ref.read(authProvider.notifier).logout(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _ProfileStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            const SizedBox(height: 6),
            Text(
              '$value',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
