// ============================================================
// FILE: admin_web/lib/features/users/presentation/user_detail_screen.dart
// DESCRIPTION: Detailed view for a single user (read-only)
// FEATURES:
// - User profile card with avatar and info
// - Edit role and suspend actions
// - Statistics cards (Points, Pickups, Redeems, Balance)
// - Recent pickups activity
// - Saved addresses list
// - Contact information display
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/admin_theme.dart';

class UserDetailScreen extends ConsumerWidget {
  final String userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button
        TextButton.icon(
          onPressed: () => context.go('/users'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to Users'),
        ),
        const SizedBox(height: 16),

        // User Profile Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AdminTheme.primaryColor,
                  child: const Text(
                    'JD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          AdminTheme.roleBadge('user'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.email,
                              size: 16, color: AdminTheme.textSecondary),
                          SizedBox(width: 8),
                          Text(
                            'john.doe@example.com',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.phone,
                              size: 16, color: AdminTheme.textSecondary),
                          SizedBox(width: 8),
                          Text(
                            '+62 812-3456-7890',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: AdminTheme.textSecondary),
                          SizedBox(width: 8),
                          Text(
                            'Joined: 15 Jan 2024',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showEditRoleDialog(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Role'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _showSuspendDialog(context),
                      icon: const Icon(Icons.block),
                      label: const Text('Suspend'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AdminTheme.errorColor,
                        side: const BorderSide(color: AdminTheme.errorColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Stats Row
        Row(
          children: const [
            Expanded(
              child: _InfoCard(
                icon: Icons.stars,
                label: 'Total Points',
                value: '1,250',
                color: AdminTheme.warningColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _InfoCard(
                icon: Icons.local_shipping,
                label: 'Pickups',
                value: '23',
                color: AdminTheme.infoColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _InfoCard(
                icon: Icons.card_giftcard,
                label: 'Redeems',
                value: '8',
                color: AdminTheme.successColor,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _InfoCard(
                icon: Icons.account_balance_wallet,
                label: 'Balance',
                value: 'Rp 125K',
                color: AdminTheme.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Recent Activity
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup History
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Pickups',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildActivityItem(
                        'Plastic - 5 kg',
                        '2 days ago',
                        'completed',
                        '+250 points',
                      ),
                      const Divider(),
                      _buildActivityItem(
                        'Paper - 3 kg',
                        '1 week ago',
                        'completed',
                        '+150 points',
                      ),
                      const Divider(),
                      _buildActivityItem(
                        'Metal - 8 kg',
                        '2 weeks ago',
                        'completed',
                        '+400 points',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Addresses
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saved Addresses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAddressItem(
                        'Home',
                        'Jl. Merdeka No. 123, Jakarta Pusat',
                        true,
                      ),
                      const Divider(),
                      _buildAddressItem(
                        'Office',
                        'Jl. Sudirman No. 456, Jakarta Selatan',
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title, String time, String status, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AdminTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdminTheme.statusChip(status, fontSize: 11),
              const SizedBox(height: 4),
              Text(
                points,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AdminTheme.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(String label, String address, bool isDefault) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AdminTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AdminTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AdminTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AdminTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select new role for this user:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: 'user',
              decoration: const InputDecoration(
                labelText: 'Role',
              ),
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'courier', child: Text('Courier')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User role updated successfully'),
                  backgroundColor: AdminTheme.successColor,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend User'),
        content: const Text(
          'Are you sure you want to suspend this user? '
          'They will not be able to access the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User suspended successfully'),
                  backgroundColor: AdminTheme.successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.errorColor,
            ),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }
}

// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
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
              label,
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
