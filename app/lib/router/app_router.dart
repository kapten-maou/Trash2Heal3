import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/providers/auth_provider.dart';

// Auth
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';

// Home
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/widgets/home_shell.dart';
import '../features/home/presentation/screens/tip_detail_screen.dart';

// Pickup
import '../features/pickup/presentation/screens/pickup_quantity_screen.dart';
import '../features/pickup/presentation/screens/pickup_address_screen.dart';
import '../features/pickup/presentation/screens/pickup_schedule_screen.dart';
import '../features/pickup/presentation/screens/pickup_review_screen.dart';
import '../features/pickup/presentation/screens/pickup_success_screen.dart';

// Points
import '../features/points/presentation/screens/points_screen.dart';
import '../features/points/presentation/screens/points_history_screen.dart';
import '../features/points/presentation/screens/redeem_screen.dart';
import '../features/points/presentation/screens/redeem_success_screen.dart';

// Profile
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/addresses_screen.dart';
import '../features/profile/presentation/screens/add_address_screen.dart';
import '../features/profile/presentation/screens/security_screen.dart';
import '../features/profile/presentation/screens/payment_methods_screen.dart';

// History
import '../features/history/presentation/screens/history_screen.dart';

// Events
import '../features/events/presentation/screens/events_screen.dart';
import '../features/events/presentation/screens/event_detail_screen.dart';

// Notifications
import '../features/notifications/presentation/screens/notifications_screen.dart';

// Chat
import '../features/chat/presentation/screens/chat_threads_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';

// Membership
import '../features/membership/presentation/screens/membership_plans_screen.dart';
import '../features/membership/presentation/screens/membership_payment_screen.dart';
import '../features/membership/presentation/screens/membership_success_screen.dart';
import '../features/membership/presentation/screens/membership_detail_screen.dart';
import '../features/membership/presentation/screens/membership_payment_waiting_screen.dart';

// Courier
import '../features/courier/presentation/screens/courier_tasks_screen.dart';
import '../features/courier/presentation/screens/courier_task_detail_screen.dart';
import '../features/courier/presentation/screens/courier_proof_screen.dart';
import '../features/courier/presentation/screens/courier_success_screen.dart';
import '../features/courier/presentation/screens/courier_dashboard_screen.dart';
import '../features/courier/presentation/screens/courier_profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Refresh notifier to rebuild GoRouter on auth/role changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this.ref) {
    _sub = ref.listen<AuthState>(authProvider, (prev, next) {
      if (prev?.role != next.role || prev?.user != next.user) {
        notifyListeners();
      }
    });
  }

  final Ref ref;
  ProviderSubscription<AuthState>? _sub;

  @override
  void dispose() {
    _sub?.close();
    super.dispose();
  }
}

GoRouter _createRouter(Ref ref) {
  final refreshNotifier = GoRouterRefreshNotifier(ref);
  String? guardRedirect(String location, AuthState auth) {
    final isAuthRoute = location == '/login' ||
        location == '/register' ||
        location == '/splash';

    if (!auth.isAuthenticated && !auth.isGuest) {
      return isAuthRoute ? null : '/login';
    }

    // Splash -> redirect by role
    if (location == '/splash') {
      return auth.isCourier ? '/courier/tasks' : '/home';
    }

    // Cross-role guards
    final isCourierRoute = location.startsWith('/courier');
    final isUserRoute = location.startsWith('/home') ||
        location.startsWith('/pickup') ||
        location.startsWith('/points') ||
        location.startsWith('/redeem') ||
        location.startsWith('/membership') ||
        location.startsWith('/profile');

    if (auth.isCourier && isUserRoute) return '/courier/tasks';
    if (auth.isUser && isCourierRoute) return '/home';

    // Auth routes when already logged in
    if ((auth.isAuthenticated || auth.isGuest) && isAuthRoute) {
      return auth.isCourier ? '/courier/tasks' : '/home';
    }

    return null;
  }

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      return guardRedirect(state.matchedLocation, auth);
    },
    routes: [
    // ===== AUTH ROUTES =====
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/membership/:planId/detail',
      builder: (context, state) {
        final planId = state.pathParameters['planId'] ?? 'gold';
        return MembershipDetailScreen(planId: planId);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // ===== MAIN ROUTES (HOME SHELL) =====
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/home/points',
          builder: (context, state) => const PointsScreen(),
        ),
        GoRoute(
          path: '/home/member',
          builder: (context, state) => const MembershipPlansScreen(),
        ),
        GoRoute(
          path: '/home/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/tips/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return TipDetailScreen(tipId: id);
          },
        ),
      ],
    ),

    // ===== PICKUP FLOW =====
    GoRoute(
      path: '/pickup/quantity',
      builder: (context, state) => const PickupQuantityScreen(),
    ),
    GoRoute(
      path: '/pickup/address',
      builder: (context, state) => const PickupAddressScreen(),
    ),
    GoRoute(
      path: '/pickup/schedule',
      builder: (context, state) => const PickupScheduleScreen(),
    ),
    GoRoute(
      path: '/pickup/review',
      builder: (context, state) => const PickupReviewScreen(),
    ),
    GoRoute(
      path: '/pickup/success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final pickupId =
            extra['pickupId'] as String? ?? state.uri.queryParameters['id'] ?? '';
        final otp = extra['otp'] as String?;
        final points =
            extra['points'] is int ? extra['points'] as int : null;
        return PickupSuccessScreen(
          pickupId: pickupId,
          otp: otp,
          estimatedPoints: points,
        );
      },
    ),

    // ===== POINTS =====
    GoRoute(
      path: '/points',
      redirect: (_, __) => '/home/points',
      builder: (context, state) => const SizedBox.shrink(),
    ),
    GoRoute(
      path: '/points/history',
      builder: (context, state) => const PointsHistoryScreen(),
    ),
    GoRoute(
      path: '/redeem',
      builder: (context, state) => const RedeemScreen(),
    ),
    GoRoute(
      path: '/redeem/success',
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] ?? 'voucher';
        final name = state.uri.queryParameters['name'] ?? '';
        final points = state.uri.queryParameters['points'] ?? '0';
        final value = state.uri.queryParameters['value'] ?? '';
        return RedeemSuccessScreen(
          type: type,
          name: name,
          points: int.tryParse(points) ?? 0,
          value: value,
        );
      },
    ),

    // ===== PROFILE =====
    GoRoute(
      path: '/profile',
      redirect: (_, __) => '/home/profile',
      builder: (context, state) => const SizedBox.shrink(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/profile/addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: '/profile/addresses/add',
      builder: (context, state) => const AddAddressScreen(),
    ),
    GoRoute(
      path: '/profile/addresses/edit/:id',
      builder: (context, state) {
        final addressId = state.pathParameters['id']!;
        return AddAddressScreen(addressId: addressId);
      },
    ),
    GoRoute(
      path: '/profile/payment-methods',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/profile/security',
      builder: (context, state) => const SecurityScreen(),
    ),

    // ===== HISTORY =====
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/history/:id',
      builder: (context, state) {
        final requestId = state.pathParameters['id']!;
        // TODO: Create HistoryDetailScreen
        return Scaffold(
          appBar: AppBar(title: const Text('Detail Penjemputan')),
          body: Center(child: Text('Request ID: $requestId')),
        );
      },
    ),

    // ===== EVENTS =====
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsScreen(),
    ),
    GoRoute(
      path: '/events/:id',
      builder: (context, state) {
        final eventId = state.pathParameters['id']!;
        return EventDetailScreen(eventId: eventId);
      },
    ),

    // ===== NOTIFICATIONS =====
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // ===== CHAT =====
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatThreadsScreen(),
    ),
    GoRoute(
      path: '/chat/:threadId',
      builder: (context, state) {
        final threadId = state.pathParameters['threadId']!;
        return ChatScreen(threadId: threadId);
      },
    ),

    // ===== MEMBERSHIP =====
    GoRoute(
      path: '/membership/plans',
      builder: (context, state) => const MembershipPlansScreen(),
    ),
    GoRoute(
      path: '/membership/:planId/detail',
      builder: (context, state) {
        final planId = state.pathParameters['planId'] ?? '';
        return MembershipDetailScreen(planId: planId);
      },
    ),
    GoRoute(
      path: '/membership/payment',
      builder: (context, state) => const MembershipPaymentScreen(),
    ),
    GoRoute(
      path: '/membership/payment/waiting',
      builder: (context, state) {
        final paymentId = state.uri.queryParameters['paymentId'] ?? '';
        final amount = state.uri.queryParameters['amount'];
        final code = state.uri.queryParameters['code'];
        return MembershipPaymentWaitingScreen(
          paymentId: paymentId,
          fallbackAmount: amount,
          fallbackCode: code,
        );
      },
    ),
    GoRoute(
      path: '/membership/success',
      builder: (context, state) {
        final paymentId = state.uri.queryParameters['paymentId'] ?? '';
        return MembershipSuccessScreen(paymentId: paymentId);
      },
    ),

    // ===== COURIER ROUTES =====
    GoRoute(
      path: '/courier/tasks',
      builder: (context, state) => const CourierTasksScreen(),
    ),
    GoRoute(
      path: '/courier/dashboard',
      builder: (context, state) => const CourierDashboardScreen(),
    ),
    GoRoute(
      path: '/courier/profile',
      builder: (context, state) => const CourierProfileScreen(),
    ),
    GoRoute(
      path: '/courier/task/:id',
      builder: (context, state) {
        final taskId = state.pathParameters['id']!;
        return CourierTaskDetailScreen(taskId: taskId);
      },
    ),
    GoRoute(
      path: '/courier/task/:id/proof',
      builder: (context, state) {
        final taskId = state.pathParameters['id']!;
        return CourierProofScreen(taskId: taskId);
      },
    ),
    GoRoute(
      path: '/courier/task/:id/success',
      builder: (context, state) {
        final taskId = state.pathParameters['id']!;
        final weight = double.tryParse(state.uri.queryParameters['weight'] ?? '');
        final points = int.tryParse(state.uri.queryParameters['points'] ?? '');
        return CourierSuccessScreen(taskId: taskId, weight: weight, points: points);
      },
    ),
  ],
);

}

final routerProvider = Provider<GoRouter>((ref) {
  return _createRouter(ref);
});
