import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/auth/presentation/screens/login_screen.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_provider.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_state.dart';
import 'package:internlink_flutter_application/features/auth/data/model/user_model.dart';
// import 'package:internlink_flutter_application/features/auth/providers/auth_notifier.dart';

class MockAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  MockAuthNotifier() : super(const AuthState.initial());

  String? lastEmail;
  String? lastPassword;

  @override
  Future<void> login(String email, String password) async {
    lastEmail = email;
    lastPassword = password;
    state = const AuthState.loading();
  }

  @override
  Future<void> logout() async {
    state = AuthState.initial();
  }

  @override
  void clearState() {
    state = const AuthState.initial();
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dob,
    required String phone,
    required String address,
  }) async {
    state = AuthState.authenticated(User(
      id: "1",
      // name: name,
      email: email,
      token: 'dummy_token',
      // gender: gender,
      // dob: dob,
      // phone: phone,
      // address: address,
      role: 'student',
    ));
  }
}

void main() {
  late MockAuthNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockAuthNotifier();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockNotifier),
      ],
      child: MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('calls login with entered credentials', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'Password1');
    // await tester.tap(find.text('Login'));
    await tester.tap(find.byKey(const Key('login_button')));

    await tester.pump();

    expect(mockNotifier.lastEmail, 'test@example.com');
    expect(mockNotifier.lastPassword, 'Password1');
  });

  testWidgets('shows loading indicator when state is loading', (WidgetTester tester) async {
    mockNotifier.state = const AuthState.loading();
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when login fails', (WidgetTester tester) async {
    mockNotifier.state = const AuthState.error('Invalid credentials');
    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}

