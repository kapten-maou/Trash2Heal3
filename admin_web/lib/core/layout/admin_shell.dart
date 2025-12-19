import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dev_session_provider.dart';

/// Main admin shell layout: sidebar + topbar + scrollable content area.
class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _collapsed = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 1024;
    final sidebarCollapsed = _collapsed && !isNarrow;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            _openSearchDialog(context),
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            _openSearchDialog(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade50,
          drawer: isNarrow
              ? Drawer(
                  child: _AdminSidebar(
                    collapsed: false,
                    onToggleCollapse: () {},
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isNarrow)
                _AdminSidebar(
                  collapsed: sidebarCollapsed,
                  onToggleCollapse: () {
                    setState(() {
                      _collapsed = !_collapsed;
                    });
                  },
                ),
              Expanded(
                child: Column(
                  children: [
                    _AdminTopBar(
                      onMenuTap: isNarrow
                          ? () => _scaffoldKey.currentState?.openDrawer()
                          : null,
                      onSearchTap: () => _openSearchDialog(context),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.grey.shade50,
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSearchDialog(BuildContext context) {
    setState(() {
      _searchQuery = '';
    });
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Search',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    onChanged: (v) => setStateDialog(() {
                      _searchQuery = v;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Search users, couriers, pickup ID...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => setStateDialog(() {
                                _searchQuery = '';
                              }),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SearchResults(query: _searchQuery),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Top navigation bar with logo, breadcrumb placeholder, search, and profile.
class _AdminTopBar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;

  const _AdminTopBar({this.onMenuTap, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (onMenuTap != null)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
              splashRadius: 22,
            ),
          if (onMenuTap != null) const SizedBox(width: 8),
          // Logo + env badge
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.recycling, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'TRASH2HEAL',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Admin Panel',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PRODUCTION',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),

          // Breadcrumb placeholder
          Expanded(
            child: Text(
              _breadcrumbFromLocation(location),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Search button
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search),
            tooltip: 'Search',
          ),
          const SizedBox(width: 8),

          // Notification bell
          _NotifButton(),
          const SizedBox(width: 8),

          // Profile
          const _ProfileMenu(),
        ],
      ),
    );
  }

  String _breadcrumbFromLocation(String location) {
    if (location == '/admin/dashboard' || location == '/admin') {
      return 'Home / Dashboard';
    }
    final segments = location.split('/').where((e) => e.isNotEmpty).toList();
    if (segments.isEmpty) return 'Home';
    final trail = ['Home', ...segments].join(' / ');
    return trail;
  }
}

/// Sidebar with grouped navigation items.
class _AdminSidebar extends StatelessWidget {
  final bool collapsed;
  final VoidCallback onToggleCollapse;

  const _AdminSidebar({
    this.collapsed = false,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final width = collapsed ? 72.0 : 240.0;

    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          if (!collapsed)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.recycling, color: Colors.green),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TRASH2HEAL',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      Text(
                        'Admin Panel',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onToggleCollapse,
              icon: Icon(
                collapsed
                    ? Icons.keyboard_double_arrow_right
                    : Icons.keyboard_double_arrow_left,
              ),
              tooltip: collapsed ? 'Expand' : 'Collapse',
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _SectionLabel('MAIN', hidden: collapsed),
                _NavTile(
                  icon: Icons.dashboard_outlined,
                  label: 'Dashboard',
                  route: '/admin/dashboard',
                  active: location.startsWith('/admin/dashboard'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.list_alt_outlined,
                  label: 'Pickups',
                  route: '/admin/pickups',
                  active: location.startsWith('/admin/pickups'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.local_shipping_outlined,
                  label: 'Couriers',
                  route: '/admin/couriers',
                  active: location.startsWith('/admin/couriers'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.people_alt_outlined,
                  label: 'Users',
                  route: '/admin/users',
                  active: location.startsWith('/admin/users'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.event_available_outlined,
                  label: 'Pickup Slots',
                  route: '/admin/pickup-slots',
                  active: location.startsWith('/admin/pickup-slots'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.payments_outlined,
                  label: 'Pickup Rates',
                  route: '/admin/pickup-rates',
                  active: location.startsWith('/admin/pickup-rates'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'Membership & Points',
                  route: '/admin/membership-points',
                  active: location.startsWith('/admin/membership-points'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.event_note_outlined,
                  label: 'Events',
                  route: '/admin/events',
                  active: location.startsWith('/admin/events'),
                  collapsed: collapsed,
                ),
                _NavTile(
                  icon: Icons.receipt_long_outlined,
                  label: 'Transactions',
                  route: '/admin/transactions',
                  active: location.startsWith('/admin/transactions'),
                  collapsed: collapsed,
                ),
                const SizedBox(height: 16),
                _SectionLabel('SYSTEM', hidden: collapsed),
                _NavTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  route: '/admin/settings',
                  active: location.startsWith('/admin/settings'),
                  collapsed: collapsed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool hidden;
  const _SectionLabel(this.text, {this.hidden = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        hidden ? '' : text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade500,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool active;
  final bool collapsed;

  const _NavTile({
    required this.icon,
    required this.label,
    required this.route,
    required this.active,
    this.collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.green.shade700 : Colors.grey.shade800;
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            if (!collapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              if (active)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
            ] else ...[
              const Spacer(),
              if (active)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotifButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final unread = snapshot.data?.docs
                .where((d) => (d.data() as Map<String, dynamic>)['read'] != true)
                .length ??
            0;
        final items = snapshot.data?.docs ?? [];

        return PopupMenuButton<int>(
          tooltip: 'Notifications',
          offset: const Offset(0, 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                enabled: false,
                child: Row(
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    if (unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$unread',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              if (items.isEmpty)
                const PopupMenuItem<int>(
                  enabled: false,
                  child: Text('No notifications'),
                )
              else
                ...items.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return PopupMenuItem<int>(
                    enabled: false,
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.green.shade600,
                      ),
                      title: Text(data['title']?.toString() ?? 'Notification'),
                      subtitle:
                          Text(data['body']?.toString() ?? 'No details'),
                    ),
                  );
                }),
            ];
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: null,
                icon: const Icon(Icons.notifications_none_outlined),
                splashRadius: 22,
              ),
              if (unread > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Admin';
    final email = user?.email ?? '';
    final initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((e) => e[0]).take(2).join()
        : 'A';

    return PopupMenuButton<int>(
      offset: const Offset(0, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => const [
        PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.history),
            title: Text('Activity Log'),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<int>(
          value: 4,
          child: ListTile(
            dense: true,
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Logout'),
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green.shade600,
            child: Text(initials.toUpperCase(),
                style: const TextStyle(color: Colors.white)),
          ),
          if (displayName.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              displayName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
      onSelected: (value) {
        if (value == 4) {
          // Reset temporary dev session flag when using hard-coded login
          ref.read(devSessionProvider.notifier).state = false;
          FirebaseAuth.instance.signOut();
          context.go('/admin/login');
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final String query;
  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.trim().length < 2) {
      return const Text(
        'Ketik minimal 2 karakter (Ctrl/Cmd+K) untuk mencari users/couriers/pickups.',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      );
    }

    return FutureBuilder<_SearchGrouped>(
      future: _performSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(minHeight: 3),
          );
        }
        if (snapshot.hasError) {
          return Text(
            'Gagal mencari: ${snapshot.error}',
            style: const TextStyle(fontSize: 12, color: Colors.redAccent),
          );
        }
        final data = snapshot.data;
        if (data == null ||
            (data.users.isEmpty &&
                data.couriers.isEmpty &&
                data.pickups.isEmpty)) {
          return const Text(
            'Tidak ada hasil.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.pickups.isNotEmpty) ...[
              const _GroupTitle('Pickups'),
              ...data.pickups
                  .map((item) => _ResultTile(
                        title: item.title,
                        subtitle: item.subtitle,
                        route: '/admin/pickups',
                      ))
                  .toList(),
              const SizedBox(height: 8),
            ],
            if (data.users.isNotEmpty) ...[
              const _GroupTitle('Users'),
              ...data.users
                  .map((item) => _ResultTile(
                        title: item.title,
                        subtitle: item.subtitle,
                        route: '/admin/users/${item.id}',
                      ))
                  .toList(),
              const SizedBox(height: 8),
            ],
            if (data.couriers.isNotEmpty) ...[
              const _GroupTitle('Couriers'),
              ...data.couriers
                  .map((item) => _ResultTile(
                        title: item.title,
                        subtitle: item.subtitle,
                        route: '/admin/couriers',
                      ))
                  .toList(),
            ],
          ],
        );
      },
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String text;
  const _GroupTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String route;

  const _ResultTile({
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        Navigator.of(context).pop();
        context.go(route);
      },
    );
  }
}

class _SearchItem {
  final String id;
  final String title;
  final String subtitle;

  _SearchItem({required this.id, required this.title, required this.subtitle});
}

class _SearchGrouped {
  final List<_SearchItem> users;
  final List<_SearchItem> couriers;
  final List<_SearchItem> pickups;

  _SearchGrouped({
    required this.users,
    required this.couriers,
    required this.pickups,
  });
}

Future<_SearchGrouped> _performSearch(String query) async {
  final q = query.trim();
  final fs = FirebaseFirestore.instance;

  Future<List<_SearchItem>> _searchCollection(
      String collection, String field) async {
    final snap = await fs
        .collection(collection)
        .orderBy(field)
        .startAt([q])
        .endAt(['$q\uf8ff'])
        .limit(5)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      final title = data['name']?.toString() ??
          data['pickupId']?.toString() ??
          d.id;
      final subtitle = data['email']?.toString() ??
          data['userId']?.toString() ??
          '';
      return _SearchItem(id: d.id, title: title, subtitle: subtitle);
    }).toList();
  }

  final usersFuture = _searchCollection('users', 'name');
  final couriersFuture = fs
      .collection('users')
      .orderBy('name')
      .startAt([q])
      .endAt(['$q\uf8ff'])
      .limit(15)
      .get()
      .then((snap) => snap.docs
          .where((d) => (d.data()['role'] ?? '') == 'courier')
          .map((d) {
            final data = d.data();
            return _SearchItem(
              id: d.id,
              title: data['name']?.toString() ?? d.id,
              subtitle: data['phone']?.toString() ?? '',
            );
          })
          .take(5)
          .toList());

  final pickupsFuture = fs
      .collection('pickups')
      .orderBy('userId')
      .startAt([q])
      .endAt(['$q\uf8ff'])
      .limit(5)
      .get()
      .then((snap) => snap.docs
          .map((d) {
            final data = d.data();
            final pickupId = d.id;
            final userId = data['userId']?.toString() ?? '';
            final zone = data['zone']?.toString() ?? '';
            return _SearchItem(
              id: pickupId,
              title: pickupId,
              subtitle: 'User: $userId • Zona: $zone',
            );
          })
          .toList());

  final results = await Future.wait([usersFuture, couriersFuture, pickupsFuture]);

  return _SearchGrouped(
    users: results[0] as List<_SearchItem>,
    couriers: results[1] as List<_SearchItem>,
    pickups: results[2] as List<_SearchItem>,
  );
}
