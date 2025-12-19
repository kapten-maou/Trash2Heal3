// ============================================================
// FILE: admin_web/lib/features/users/presentation/users_list_screen.dart
// DESCRIPTION: List view for users (read-only)
// FEATURES:
// - Statistics cards (Total, Couriers, New users)
// - DataTable with user information
// - Search functionality
// - Filter by role
// - Role badges display
// - View user detail action
// - Avatar display
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});

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
                  hintText: 'Search users by name or email...',
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
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Show filter dialog
              },
              icon: const Icon(Icons.filter_list),
              label: const Text('Filter'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Stats Cards
        Row(
          children: const [
            Expanded(
              child: _UserStatCard(
                title: 'Total Users',
                value: '1,234',
                icon: Icons.people,
                color: AdminTheme.infoColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _UserStatCard(
                title: 'Active Couriers',
                value: '45',
                icon: Icons.local_shipping,
                color: AdminTheme.warningColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _UserStatCard(
                title: 'New This Month',
                value: '128',
                icon: Icons.person_add,
                color: AdminTheme.successColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Users Table
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Users',
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
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Points')),
                      DataColumn(label: Text('Joined')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: List.generate(
                      10,
                      (index) => DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AdminTheme.primaryColor,
                                  child: Text(
                                    'U${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'User ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text('user${index + 1}@example.com')),
                          DataCell(Text('+62812345${6780 + index}')),
                          DataCell(AdminTheme.roleBadge(
                            index % 3 == 0 ? 'courier' : 'user',
                          )),
                          DataCell(
                            Text(
                              '${(index + 1) * 150}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AdminTheme.warningColor,
                              ),
                            ),
                          ),
                          DataCell(Text('${index + 1} Jan 2024')),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: () => context.go('/users/user_$index'),
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
}

// User Stat Card Widget
class _UserStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _UserStatCard({
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      fontSize: 14,
                      color: AdminTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
