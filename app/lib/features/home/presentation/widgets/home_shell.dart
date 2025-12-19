import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_provider.dart';

/// Shell wrapper for user flow with bottom nav + pickup FAB
class HomeShell extends ConsumerWidget {
  final Widget child;
  const HomeShell({super.key, required this.child});

  int _currentIndex(String location) {
    if (location.startsWith('/home/points') || location == '/points') {
      return 1;
    }
    if (location.startsWith('/home/member') ||
        location.startsWith('/membership')) {
      return 2;
    }
    if (location.startsWith('/home/profile') ||
        location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/home/points');
        break;
      case 2:
        context.go('/home/member');
        break;
      case 3:
        context.go('/home/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final location = GoRouterState.of(context).matchedLocation;

    if (auth.isCourier) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (location.startsWith('/home')) {
          context.go('/courier/tasks');
        }
      });
    }
    final currentIndex = _currentIndex(location);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pickup/quantity'),
        icon: const Icon(Icons.add),
        label: const Text('Pickup'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home,
                    label: 'Home',
                    isActive: currentIndex == 0,
                    onTap: () => _onTap(context, 0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.star,
                    label: 'Points',
                    isActive: currentIndex == 1,
                    onTap: () => _onTap(context, 1),
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(
                  child: _NavItem(
                    icon: Icons.card_membership,
                    label: 'Member',
                    isActive: currentIndex == 2,
                    onTap: () => _onTap(context, 2),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.person,
                    label: 'Profile',
                    isActive: currentIndex == 3,
                    onTap: () => _onTap(context, 3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? Theme.of(context).colorScheme.primary : const Color(0xFF9CA3AF);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
