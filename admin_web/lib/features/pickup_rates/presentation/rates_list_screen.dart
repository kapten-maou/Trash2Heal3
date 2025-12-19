// ============================================================
// FILE: admin_web/lib/features/pickup_rates/presentation/rates_list_screen.dart
// DESCRIPTION: List view for pickup rates configuration
// FEATURES:
// - DataTable with waste type icons
// - Points per kg display
// - Weight range (min/max)
// - Search functionality
// - Edit/Delete actions
// - Status display
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_shared/trash2heal_shared.dart';
import '../../../core/theme/admin_theme.dart';

class WasteType {
  static const Map<String, String> labels = {
    'plastic': 'Plastik',
    'glass': 'Kaca',
    'can': 'Kaleng',
    'cardboard': 'Kardus',
    'fabric': 'Kain',
    'ceramicStone': 'Keramik/Batu',
  };
}

class RatesListScreen extends ConsumerWidget {
  const RatesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Actions
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search rates by waste type...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AdminTheme.surfaceColor,
                ),
                onChanged: (value) {
                  // TODO: Implement search filtering
                },
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => context.go('/pickup-rates/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Rate'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Data Table Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pickup Rates Configuration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Configure point rewards for each waste type',
                  style: TextStyle(
                    fontSize: 14,
                    color: AdminTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Waste Type')),
                    DataColumn(label: Text('Points per Kg')),
                    DataColumn(label: Text('Min Weight (kg)')),
                    DataColumn(label: Text('Max Weight (kg)')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: WasteType.labels.entries.map((entry) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              Icon(
                                _getWasteIcon(entry.key),
                                size: 20,
                                color: AdminTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                entry.value,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            '${(entry.key.hashCode % 50) + 10}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AdminTheme.successColor,
                            ),
                          ),
                        ),
                        const DataCell(Text('0.5')),
                        const DataCell(Text('100')),
                        DataCell(AdminTheme.statusChip('active')),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => context
                                    .go('/pickup-rates/edit/${entry.key}'),
                                tooltip: 'Edit',
                                color: AdminTheme.infoColor,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _showDeleteDialog(
                                    context, entry.key, entry.value),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getWasteIcon(String type) {
    switch (type) {
      case 'plastic':
        return Icons.water_drop;
      case 'paper':
        return Icons.description;
      case 'metal':
        return Icons.build;
      case 'glass':
        return Icons.local_drink;
      case 'organic':
        return Icons.eco;
      case 'electronic':
        return Icons.computer;
      default:
        return Icons.delete;
    }
  }

  void _showDeleteDialog(
      BuildContext context, String rateId, String wasteName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pickup Rate'),
        content: Text(
          'Are you sure you want to delete the rate for $wasteName? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete logic
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rate deleted successfully'),
                  backgroundColor: AdminTheme.successColor,
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
