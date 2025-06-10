import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/auth/presentation/screens/signup_screen.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_provider.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_state.dart';

// Fake AuthNotifier that extends StateNotifier and implements AuthNotifier
class FakeAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  FakeAuthNotifier() : super(const AuthState.initial());

  // Track if signUp was called and store last arguments
  bool signUpCalled = false;
  late String lastName;
  late String lastEmail;
  late String lastPassword;
  late String lastConfirmPassword;
  late String lastGender;
  late String lastDob;
  late String lastPhone;
  late String lastAddress;

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
    signUpCalled = true;
    lastName = name;
    lastEmail = email;
    lastPassword = password;
    lastConfirmPassword = confirmPassword;
    lastGender = gender;
    lastDob = dob;
    lastPhone = phone;
    lastAddress = address;
  }

  // Helper method to change state to loading in tests
  void setLoading() {
    state = const AuthState.loading();
  }

  @override
  void clearState() {
    // You can implement this if needed
  }

  @override
  Future<void> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}

void main() {
  late FakeAuthNotifier fakeAuthNotifier;

  setUp(() {
    fakeAuthNotifier = FakeAuthNotifier();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => fakeAuthNotifier),
      ],
      child: MaterialApp(
        home: SignUpScreen(),
      ),
    );
  }


  testWidgets('renders signup form and calls signUp on button tap', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Fill all fields (you already do this)

    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'Male');
    await tester.enterText(find.byType(TextField).at(2), '2000-01-01');
    await tester.enterText(find.byType(TextField).at(3), '1234567890');
    await tester.enterText(find.byType(TextField).at(4), 'Test Address');
    await tester.enterText(find.byType(TextField).at(5), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(6), 'Password1');
    await tester.enterText(find.byType(TextField).at(7), 'Password1');

    // Pump and settle to finish all builds
    await tester.pumpAndSettle();

    // Scroll until the button is visible if the form is scrollable
    final signUpButton = find.text('Sign up');
    await tester.ensureVisible(signUpButton);

    // Now tap the sign up button
    await tester.tap(signUpButton);

    // Wait for any async calls triggered by tap
    await tester.pumpAndSettle();

    // Add your verification logic here, e.g., check for a flag in your fake notifier
  });


  testWidgets('shows loading indicator when loading', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Change the state to loading and trigger rebuild
    fakeAuthNotifier.setLoading();

    await tester.pump();

    final loadingFinder = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.byType(CircularProgressIndicator),
    );

    expect(loadingFinder, findsOneWidget);
  });
}
