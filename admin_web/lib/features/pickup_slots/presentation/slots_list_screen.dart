import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../../core/theme/admin_theme.dart';
import '../providers/pickup_slots_provider.dart';

class SlotsListScreen extends ConsumerStatefulWidget {
  const SlotsListScreen({super.key});

  @override
  ConsumerState<SlotsListScreen> createState() => _SlotsListScreenState();
}

class _SlotsListScreenState extends ConsumerState<SlotsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pickupSlotsProvider.notifier).loadSlots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pickupSlotsProvider);
    final slots = state.filteredSlots;
    final isLoading = state.isLoading || state.isSaving;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Actions
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari slot (waktu/zona/tanggal)...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AdminTheme.surfaceColor,
                ),
                onChanged: (value) {
                  ref.read(pickupSlotsProvider.notifier).setSearchQuery(value);
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              // Use full admin path so it matches GoRouter config
              onPressed: () => context.go('/admin/pickup-slots/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Slot'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (state.successMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ),

        // Data Table Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Pickup Slots',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isLoading) ...[
                      const SizedBox(width: 12),
                      const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                if (slots.isEmpty && !isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text('Belum ada slot'),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Zona')),
                        DataColumn(label: Text('Waktu')),
                        DataColumn(label: Text('Kapasitas (kg)')),
                        DataColumn(label: Text('Terpakai (kg)')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: slots.map((slot) {
                        final dateStr =
                            DateFormat('dd MMM yyyy').format(slot.date);
                        return DataRow(
                          cells: [
                            DataCell(Text(dateStr)),
                            DataCell(Text(slot.zone)),
                            DataCell(Text(slot.timeRange)),
                            DataCell(Text('${slot.capacityWeightKg}')),
                            DataCell(Text('${slot.usedWeightKg}')),
                            DataCell(AdminTheme.statusChip(
                                slot.isActive ? 'active' : 'inactive')),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () =>
                                        context.go('/pickup-slots/edit/${slot.id}'),
                                    tooltip: 'Edit',
                                    color: AdminTheme.infoColor,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      slot.isActive
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                    onPressed: () => ref
                                        .read(pickupSlotsProvider.notifier)
                                        .toggleSlotStatus(slot.id),
                                    tooltip: slot.isActive
                                        ? 'Nonaktifkan'
                                        : 'Aktifkan',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () =>
                                        _showDeleteDialog(context, slot.id),
                                    tooltip: 'Delete',
                                    color: AdminTheme.errorColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String slotId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pickup Slot'),
        content: const Text(
          'Yakin hapus slot ini? Slot dengan booking tidak bisa dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final ok = await ref
                  .read(pickupSlotsProvider.notifier)
                  .deleteSlot(slotId);
              final state = ref.read(pickupSlotsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok
                        ? 'Slot deleted'
                        : (state.error ?? 'Gagal menghapus slot'),
                  ),
                  backgroundColor:
                      ok ? AdminTheme.successColor : AdminTheme.errorColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
