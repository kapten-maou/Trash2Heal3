// ============================================================
// FILE: admin_web/lib/features/transactions/presentation/transactions_list_screen.dart
// DESCRIPTION: List view for all transactions (read-only)
// FEATURES:
// - Statistics cards (Revenue, Pending, Completed, Failed)
// - DataTable with transaction details
// - Type filter (All, Pickup, Redeem, Membership)
// - Status filter (All, Completed, Pending, Failed)
// - Search functionality
// - Export button (TODO)
// - Type chips with icons
// - Payment method display
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/admin_theme.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  String _filterType = 'all';
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header Actions
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
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

            // Type Filter
            DropdownButton<String>(
              value: _filterType,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'pickup', child: Text('Pickup')),
                DropdownMenuItem(value: 'redeem', child: Text('Redeem')),
                DropdownMenuItem(
                    value: 'membership', child: Text('Membership')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _filterType = value);
                }
              },
            ),
            const SizedBox(width: 8),

            // Status Filter
            DropdownButton<String>(
              value: _filterStatus,
              underline: Container(),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'failed', child: Text('Failed')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _filterStatus = value);
                }
              },
            ),
            const SizedBox(width: 16),

            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement export functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Export functionality coming soon'),
                    backgroundColor: AdminTheme.infoColor,
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Export'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Summary Cards
        Row(
          children: const [
            Expanded(
              child: _TransactionStatCard(
                title: 'Total Revenue',
                value: 'Rp 12.5M',
                icon: Icons.attach_money,
                color: AdminTheme.successColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _TransactionStatCard(
                title: 'Pending',
                value: 'Rp 1.2M',
                icon: Icons.pending,
                color: AdminTheme.warningColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _TransactionStatCard(
                title: 'Completed',
                value: '1,234',
                icon: Icons.check_circle,
                color: AdminTheme.infoColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _TransactionStatCard(
                title: 'Failed',
                value: '45',
                icon: Icons.error,
                color: AdminTheme.errorColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Transactions Table
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Transaction ID')),
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Method')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: List.generate(
                      15,
                      (index) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              'TRX-${1000 + index}',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(Text('User ${index + 1}')),
                          DataCell(_buildTypeChip(_getType(index))),
                          DataCell(
                            Text(
                              'Rp ${(index + 1) * 50}K',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(Text(_getMethod(index))),
                          DataCell(AdminTheme.statusChip(_getStatus(index))),
                          DataCell(Text('${15 + index} Jan 2024')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () {
                                // TODO: Show transaction detail dialog
                                _showTransactionDetail(context, index);
                              },
                              tooltip: 'View Details',
                              color: AdminTheme.infoColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getType(int index) {
    const types = ['pickup', 'redeem', 'membership'];
    return types[index % 3];
  }

  String _getStatus(int index) {
    const statuses = ['completed', 'pending', 'failed'];
    return statuses[index % 3];
  }

  String _getMethod(int index) {
    const methods = ['VA BCA', 'QRIS', 'Points'];
    return methods[index % 3];
  }

  Widget _buildTypeChip(String type) {
    Color color;
    IconData icon;

    switch (type) {
      case 'pickup':
        color = AdminTheme.infoColor;
        icon = Icons.local_shipping;
        break;
      case 'redeem':
        color = AdminTheme.warningColor;
        icon = Icons.card_giftcard;
        break;
      case 'membership':
        color = AdminTheme.primaryColor;
        icon = Icons.card_membership;
        break;
      default:
        color = AdminTheme.textSecondary;
        icon = Icons.receipt;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transaction Details - TRX-${1000 + index}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('User', 'User ${index + 1}'),
              _buildDetailRow('Type', _getType(index).toUpperCase()),
              _buildDetailRow('Amount', 'Rp ${(index + 1) * 50}K'),
              _buildDetailRow('Method', _getMethod(index)),
              _buildDetailRow('Date', '${15 + index} Jan 2024'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Status: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  AdminTheme.statusChip(_getStatus(index)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AdminTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// Transaction Stat Card Widget
class _TransactionStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _TransactionStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AdminTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
