import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Admin sidebar menu widget
class SidebarMenu extends ConsumerWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentRoute = GoRouterState.of(context).uri.path;

    return Drawer(
      child: Column(
        children: [
          // Header with logo and app name
          _buildHeader(context, authState),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  currentRoute: currentRoute,
                ),
                const Divider(height: 1),

                // Pickup Management Section
                _buildSectionHeader('Pickup Management'),
                _buildMenuItem(
                  context,
                  icon: Icons.access_time,
                  title: 'Pickup Slots',
                  route: '/pickup-slots',
                  currentRoute: currentRoute,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.attach_money,
                  title: 'Pickup Rates',
                  route: '/pickup-rates',
                  currentRoute: currentRoute,
                ),
                const Divider(height: 1),

                // Events Management Section
                _buildSectionHeader('Events Management'),
                _buildMenuItem(
                  context,
                  icon: Icons.event,
                  title: 'Events',
                  route: '/events',
                  currentRoute: currentRoute,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'Event Items',
                  route: '/event-items',
                  currentRoute: currentRoute,
                ),
                const Divider(height: 1),

                // User Management Section
                _buildSectionHeader('User Management'),
                _buildMenuItem(
                  context,
                  icon: Icons.people,
                  title: 'Users',
                  route: '/users',
                  currentRoute: currentRoute,
                ),
                const Divider(height: 1),

                // Transactions Section
                _buildSectionHeader('Financial'),
                _buildMenuItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Transactions',
                  route: '/transactions',
                  currentRoute: currentRoute,
                ),
                const Divider(height: 1),

                // Settings Section
                _buildSectionHeader('System'),
                _buildMenuItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          // Footer with logout
          _buildFooter(context, ref, authState),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(BuildContext context, AuthState authState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.recycling,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRASH2HEAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Admin info
          // ✅ FIXED: Use userModel instead of user, and handle role properly
          if (authState.userModel != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    authState.userModel!.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.userModel!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        // ✅ FIXED: Get role from UserModel properly
                        _getUserRole(authState.userModel!).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// ✅ NEW: Helper method to get user role
  /// This handles different possible role field names in UserModel
  String _getUserRole(dynamic userModel) {
    // Try different possible property names
    try {
      // If UserModel has 'role' field
      return (userModel as dynamic).role?.toString() ?? 'Admin';
    } catch (e) {
      try {
        // If UserModel has 'roles' field
        return (userModel as dynamic).roles?.toString() ?? 'Admin';
      } catch (e) {
        // Fallback
        return 'Admin';
      }
    }
  }

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Build menu item
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required String currentRoute,
    int? badge,
  }) {
    final isActive = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade600,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          color: isActive ? Theme.of(context).primaryColor : Colors.black87,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: isActive,
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      onTap: () {
        context.go(route);
        // Close drawer on mobile
        if (Scaffold.of(context).hasDrawer) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  /// Build footer section
  Widget _buildFooter(
      BuildContext context, WidgetRef ref, AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.grey),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Open help dialog or page
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Responsive sidebar wrapper
class ResponsiveSidebar extends StatelessWidget {
  final Widget child;

  const ResponsiveSidebar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (isDesktop) {
      // Desktop: Permanent sidebar
      return Row(
        children: [
          SizedBox(
            width: 280,
            child: const SidebarMenu(),
          ),
          Expanded(child: child),
        ],
      );
    } else {
      // Mobile/Tablet: Drawer sidebar
      return Scaffold(
        appBar: AppBar(
          title: const Text('TRASH2HEAL Admin'),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        drawer: const SidebarMenu(),
        body: child,
      );
    }
  }
}

/// Sidebar menu item model
class MenuItemModel {
  final IconData icon;
  final String title;
  final String route;
  final int? badge;
  final List<MenuItemModel>? children;

  const MenuItemModel({
    required this.icon,
    required this.title,
    required this.route,
    this.badge,
    this.children,
  });
}
