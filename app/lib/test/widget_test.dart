import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trash2heal_app/main.dart';
import 'package:trash2heal_app/router/app_router.dart'; // untuk routerProvider

void main() {
  testWidgets('app builds with test router', (tester) async {
    final testRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home Test')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(testRouter), // inject router dummy
        ],
        child:
            const Trash2HealApp(), // hati-hati: ini masih memakai AppConfig di build
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Home Test'), findsOneWidget);
  });
}
