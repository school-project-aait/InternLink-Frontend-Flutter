import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/header_component.dart';

void main() {
  group('HeaderComponent', () {
    testWidgets('renders correctly with logo and button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: HeaderComponent(),
        ),
      ));

      expect(find.text('Intern'), findsOneWidget);
      expect(find.text('Link'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('navigates to login page on logout', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: HeaderComponent()),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(body: Text('Login Page')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
