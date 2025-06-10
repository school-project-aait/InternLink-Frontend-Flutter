import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:internlink_flutter_application/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Mock flutter_secure_storage
  const MethodChannel secureStorageChannel =
  MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    secureStorageChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'delete':
          return null;
        case 'write':
          return null;
        case 'read':
          return 'mocked_token'; // Return a dummy token or null
        default:
          return null;
      }
    });
  });

  tearDown(() {
    secureStorageChannel.setMockMethodCallHandler(null);
  });

  group('Auth Integration Test', () {
    testWidgets('Signup, Login, and Logout Flow', (WidgetTester tester) async {
      app.main(); // Launch app
      await tester.pumpAndSettle();

      // Navigate to signup page using correct key from your login screen
      final signupButton = find.byKey(const Key('go_to_signup_button'));
      expect(signupButton, findsOneWidget);
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // Fill signup form - keys must match your signup screen keys exactly
      await tester.enterText(find.byKey(const Key('signup_name_field')), 'Test User');
      await tester.enterText(find.byKey(const Key('signup_gender_field')), 'Male');
      await tester.enterText(find.byKey(const Key('signup_dob_field')), '1990-01-01');
      await tester.enterText(find.byKey(const Key('signup_phone_field')), '+251912345678');
      await tester.enterText(find.byKey(const Key('signup_address_field')), 'Addis Ababa');
      await tester.enterText(find.byKey(const Key('signup_email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('signup_password_field')), 'Password1');
      await tester.enterText(find.byKey(const Key('signup_confirm_password_field')), 'Password1');

      final signupSubmitButton = find.byKey(const Key('signup_submit_button'));
      expect(signupSubmitButton, findsOneWidget);
      await tester.tap(signupSubmitButton);
      await tester.pumpAndSettle();

      // Expect success snackbar or redirect to login
      expect(find.textContaining('success'), findsOneWidget);

      // Now login
      await tester.enterText(find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('login_password_field')), 'Password1');

      final loginButton = find.byKey(const Key('login_button'));
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Expect login success message and home screen or route change
      expect(find.text('Login successful'), findsOneWidget);

      // TODO: Add logout and verify if you have logout functionality

    });
  });
}

