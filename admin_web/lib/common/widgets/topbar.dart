import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';




String _getUserRoleLabel(AuthState authState) {
  final user = authState.user;
  if (user == null) return '';

  // role disimpan sebagai string: 'admin', 'courier', 'user'
  final role = user.role.toLowerCase();

  if (role == 'admin') return 'ADMIN';
  if (role == 'courier') return 'COURIER';
  return 'USER';
}


/// Admin dashboard top bar
class AdminTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AdminTopBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: !isDesktop, // Show menu button on mobile
      title: Row(
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Breadcrumb if desktop
          if (isDesktop) ...[
            const SizedBox(width: 16),
            _buildBreadcrumb(context),
          ],
        ],
      ),
      actions: [
        // Search button
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black54),
          tooltip: 'Search',
          onPressed: () {
            // TODO: Open search dialog
            showSearch(
              context: context,
              delegate: AdminSearchDelegate(),
            );
          },
        ),

        // Notifications
        _buildNotificationButton(context),

        const SizedBox(width: 8),

        // Custom actions
        if (actions != null) ...actions!,

        // User menu
        _buildUserMenu(context, ref, authState),

        const SizedBox(width: 16),
      ],
    );
  }

  /// Build breadcrumb navigation
  Widget _buildBreadcrumb(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final segments =
        currentRoute.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        ...List.generate(segments.length, (index) {
          final segment = segments[index];
          final isLast = index == segments.length - 1;

          return Row(
            children: [
              Text(
                _formatSegment(segment),
                style: TextStyle(
                  color: isLast ? Colors.black87 : Colors.grey,
                  fontSize: 14,
                  fontWeight: isLast ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
              if (!isLast) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
              ],
            ],
          );
        }),
      ],
    );
  }

  /// Format breadcrumb segment
  String _formatSegment(String segment) {
    return segment
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Build notification button
  Widget _buildNotificationButton(BuildContext context) {
    // TODO: Get unread count from provider
    const unreadCount = 3;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black54),
          tooltip: 'Notifications',
          onPressed: () {
            _showNotificationsPanel(context);
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 9 ? '9+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  /// Show notifications panel
  void _showNotificationsPanel(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // TODO: Mark all as read
                      },
                      child: const Text('Mark all as read'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Notifications list
              Expanded(
                child: ListView.separated(
                  itemCount: 5, // TODO: Get from provider
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.info, color: Colors.blue),
                      ),
                      title: const Text('New pickup request'),
                      subtitle: const Text('User John Doe requested pickup'),
                      trailing: const Text(
                        '2m ago',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        // TODO: Navigate to notification detail
                      },
                    );
                  },
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to full notifications page
                  },
                  child: const Text('View all notifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build user menu
  Widget _buildUserMenu(
      BuildContext context, WidgetRef ref, AuthState authState) {
    if (authState.user == null) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                authState.user!.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  authState.user!.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getUserRoleLabel(authState),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: const Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 12),
              Text('Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: const Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case 'profile':
            // TODO: Navigate to profile
            break;
          case 'settings':
            context.go('/settings');
            break;
          case 'logout':
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

            if (confirm == true && context.mounted) {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            }
            break;
        }
      },
    );
  }
}

/// Admin search delegate
class AdminSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement search results
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Implement search suggestions
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('Recent searches will appear here'),
          onTap: () {},
        ),
      ],
    );
  }




}


