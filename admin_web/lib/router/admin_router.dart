import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import screens (will be created next)
import '../core/providers/dev_session_provider.dart';
import '../features/auth/presentation/admin_login_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/pickup_slots/presentation/slots_list_screen.dart';
import '../features/pickup_slots/presentation/slot_form_screen.dart';
import '../features/pickup_rates/presentation/rates_list_screen.dart';
import '../features/pickup_rates/presentation/rate_form_screen.dart';
import '../features/events/presentation/events_list_screen.dart';
import '../features/events/presentation/event_form_screen.dart';
import '../features/event_items/presentation/event_items_list_screen.dart';
import '../features/event_items/presentation/event_item_form_screen.dart';
import '../features/users/presentation/users_list_screen.dart';
import '../features/users/presentation/user_detail_screen.dart';
import '../features/transactions/presentation/transactions_list_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/pickups/presentation/screens/pickups_screen.dart';
import '../features/couriers/presentation/screens/couriers_screen.dart';
import '../features/membership_points/presentation/screens/membership_points_screen.dart';
import '../core/layout/admin_shell.dart';

/// Router provider for admin dashboard
final adminRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(_authStateStreamProvider);
  final devSession = ref.watch(devSessionProvider);

  return GoRouter(
    initialLocation: '/admin/dashboard',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null || devSession;
      final isLoginRoute = state.matchedLocation == '/admin/login';
      if (!isLoggedIn && !isLoginRoute) return '/admin/login';
      if (isLoggedIn && isLoginRoute) return '/admin/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/admin/login',
        name: 'login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        name: 'dashboard',
        builder: (context, state) => AdminShell(child: const DashboardScreen()),
      ),
      GoRoute(
        path: '/admin/pickups',
        name: 'pickups',
        builder: (context, state) => AdminShell(child: const PickupsScreen()),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'users',
        builder: (context, state) => AdminShell(child: const UsersListScreen()),
        routes: [
          GoRoute(
            path: ':id',
            name: 'user-detail',
            builder: (context, state) {
              final userId = state.pathParameters['id']!;
              return AdminShell(child: UserDetailScreen(userId: userId));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/couriers',
        name: 'couriers',
        builder: (context, state) => AdminShell(child: const CouriersScreen()),
      ),
      GoRoute(
        path: '/admin/membership-points',
        name: 'membership-points',
        builder: (context, state) =>
            AdminShell(child: const MembershipPointsScreen()),
      ),
      GoRoute(
        path: '/admin/pickup-slots',
        name: 'pickup-slots',
        builder: (context, state) => AdminShell(child: const SlotsListScreen()),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-slot',
            builder: (context, state) => AdminShell(child: const SlotFormScreen()),
          ),
          GoRoute(
            path: 'edit/:id',
            name: 'edit-slot',
            builder: (context, state) {
              final slotId = state.pathParameters['id']!;
              return AdminShell(child: SlotFormScreen(slotId: slotId));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/pickup-rates',
        name: 'pickup-rates',
        builder: (context, state) =>
            AdminShell(child: const RatesListScreen()),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-rate',
            builder: (context, state) => AdminShell(child: const RateFormScreen()),
          ),
          GoRoute(
            path: 'edit/:id',
            name: 'edit-rate',
            builder: (context, state) {
              final rateId = state.pathParameters['id']!;
              return AdminShell(child: RateFormScreen(rateId: rateId));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/admin/events',
        name: 'events',
        builder: (context, state) => AdminShell(child: const EventsListScreen()),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add-event',
            builder: (context, state) => AdminShell(child: const EventFormScreen()),
          ),
          GoRoute(
            path: 'edit/:id',
            name: 'edit-event',
            builder: (context, state) {
              final eventId = state.pathParameters['id']!;
              return AdminShell(child: EventFormScreen(eventId: eventId));
            },
          ),
          GoRoute(
            path: ':eventId/items',
            name: 'event-items',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return AdminShell(child: EventItemsListScreen(eventId: eventId));
            },
            routes: [
              GoRoute(
                path: 'add',
                name: 'add-event-item',
                builder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  return AdminShell(child: EventItemFormScreen(eventId: eventId));
                },
              ),
              GoRoute(
                path: 'edit/:itemId',
                name: 'edit-event-item',
                builder: (context, state) {
                  final eventId = state.pathParameters['eventId']!;
                  final itemId = state.pathParameters['itemId']!;
                  return AdminShell(
                    child: EventItemFormScreen(
                      eventId: eventId,
                      itemId: itemId,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin/transactions',
        name: 'transactions',
        builder: (context, state) =>
            AdminShell(child: const TransactionsListScreen()),
      ),
      GoRoute(
        path: '/admin/settings',
        name: 'settings',
        builder: (context, state) => AdminShell(child: const SettingsScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/admin/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Auth state stream provider
final _authStateStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
