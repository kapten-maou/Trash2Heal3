import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/courier_provider.dart';

class CourierDashboardScreen extends ConsumerWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courierProvider);
    final today = state.todayTasks.length;
    final upcoming = state.upcomingTasks.length;
    final completed = state.completedTasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kurir'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(courierProvider.notifier).loadTasks(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                _StatCard(label: 'Hari Ini', value: today, color: Colors.green),
                const SizedBox(width: 12),
                _StatCard(
                    label: 'Mendatang', value: upcoming, color: Colors.orange),
                const SizedBox(width: 12),
                _StatCard(
                    label: 'Selesai', value: completed, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Tugas Hari Ini',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (state.todayTasks.isEmpty)
              const Text('Tidak ada tugas hari ini',
                  style: TextStyle(color: Color(0xFF6B7280)))
            else
              ...state.todayTasks.take(3).map(
                (t) => Card(
                  child: ListTile(
                    title: Text('#${t.id.substring(0, 8)}'),
                    subtitle: Text(
                        '${t.timeRange} • Zona ${t.zone}\nEstimasi: ${t.estimatedWeight.toStringAsFixed(1)} kg'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard(
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
