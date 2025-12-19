// ============================================================
// FILE: admin_web/lib/features/event_items/presentation/event_items_list_screen.dart
// DESCRIPTION: List view for event items (nested under events)
// FEATURES:
// - Breadcrumb navigation
// - Event info card
// - DataTable with item details
// - Add new item button
// - Edit/Delete actions
// - Stock and claimed count display
// - Status badges
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class EventItemsListScreen extends ConsumerWidget {
  final String eventId;

  const EventItemsListScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Breadcrumb & Actions
        Row(
          children: [
            TextButton.icon(
              onPressed: () => context.go('/events'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Events'),
            ),
            const SizedBox(width: 8),
            const Text(
              '/',
              style: TextStyle(color: AdminTheme.textSecondary),
            ),
            const SizedBox(width: 8),
            const Text(
              'Event Items',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => context.go('/events/$eventId/items/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Event Info Card
        Card(
          color: AdminTheme.primaryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: AdminTheme.primaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Event Name Here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AdminTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '15 Jan - 20 Jan 2024',
                            style: TextStyle(
                              fontSize: 14,
                              color: AdminTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          AdminTheme.statusChip('active', fontSize: 11),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/events/edit/$eventId'),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Event'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Items Table
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Event Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AdminTheme.infoColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '5 items',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AdminTheme.infoColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Cost (Points)')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Claimed')),
                    DataColumn(label: Text('Available')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: List.generate(
                    5,
                    (index) {
                      final stock = 50 - index * 5;
                      final claimed = index * 8;
                      final available = stock - claimed;

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AdminTheme.primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.card_giftcard,
                                    color: AdminTheme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Item ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              '${(index + 1) * 100}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.warningColor,
                              ),
                            ),
                          ),
                          DataCell(Text('$stock')),
                          DataCell(Text('$claimed')),
                          DataCell(
                            Text(
                              '$available',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: available > 20
                                    ? AdminTheme.successColor
                                    : available > 10
                                        ? AdminTheme.warningColor
                                        : AdminTheme.errorColor,
                              ),
                            ),
                          ),
                          DataCell(AdminTheme.statusChip('active')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => context.go(
                                      '/events/$eventId/items/edit/item_$index'),
                                  tooltip: 'Edit',
                                  color: AdminTheme.infoColor,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _showDeleteDialog(context, 'item_$index'),
                                  tooltip: 'Delete',
                                  color: AdminTheme.errorColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event Item'),
        content: const Text(
          'Are you sure you want to delete this item? '
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
                  content: Text('Item deleted successfully'),
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
