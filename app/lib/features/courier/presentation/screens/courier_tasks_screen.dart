import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/courier_provider.dart';
import '../../widgets/task_card.dart';

class CourierTasksScreen extends ConsumerStatefulWidget {
  const CourierTasksScreen({super.key});

  @override
  ConsumerState<CourierTasksScreen> createState() => _CourierTasksScreenState();
}

class _CourierTasksScreenState extends ConsumerState<CourierTasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(courierProvider.notifier).loadTasks());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courierState = ref.watch(courierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // TODO: Open drawer
          },
        ),
        title: const Text(
          'TUGAS HARI INI',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/courier/profile'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Hari Ini'),
            Tab(text: 'Mendatang'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(courierProvider.notifier).loadTasks(),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTaskList(courierState.todayTasks, 'Hari Ini'),
            _buildTaskList(courierState.upcomingTasks, 'Mendatang'),
            _buildTaskList(courierState.completedTasks, 'Selesai'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List tasks, String type) {
    return tasks.isEmpty
        ? _buildEmptyState(type)
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${tasks.length} penjemputan • Zona A',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ...tasks.map((task) {
                return TaskCard(
                  task: task,
                  onTap: () => context.push('/courier/task/${task.id}'),
                );
              }).toList(),
            ],
          );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_shipping, size: 80, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          Text(
            type == 'Hari Ini'
                ? 'Belum ada penjemputan\nuntuk hari ini'
                : type == 'Mendatang'
                    ? 'Tidak ada penjemputan mendatang'
                    : 'Belum ada penjemputan selesai',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nikmati waktu istirahat! 😊',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
