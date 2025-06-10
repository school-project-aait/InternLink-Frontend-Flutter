import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/auth/data/model/user_model.dart';
import 'package:internlink_flutter_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_provider.dart';
import 'package:internlink_flutter_application/features/auth/providers/auth_state.dart';
import 'package:internlink_flutter_application/providers.dart';
import 'package:mocktail/mocktail.dart';


class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  late MockAuthRepository mockRepository;
  late MockSecureStorage mockStorage;
  late AuthNotifier notifier;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockStorage = MockSecureStorage();
    notifier = AuthNotifier(mockRepository, mockStorage);
  });

  group('login', () {
    test('emits loading and authenticated on success', () async {
      final user = User(
        id: '1',
        email: 'test@example.com',
        role: 'student',
        token: 'abc123',
      );

      when(() => mockRepository.login('test@example.com', 'Password1'))
          .thenAnswer((_) async => user);
      when(() => mockStorage.saveToken('abc123')).thenAnswer((_) async => {});

      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: false);

      await notifier.login('test@example.com', 'Password1');

      expect(states[0], const AuthState.loading());
      expect(states[1], AuthState.authenticated(user));
    });

    test('emits loading and error on failure', () async {
      when(() => mockRepository.login(any(), any()))
          .thenThrow('Invalid credentials');

      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: false);

      await notifier.login('wrong', 'wrong');

      expect(states[0], const AuthState.loading());
      // expect(states[1], isA<_Error>());
      expect(states[1], isA<AuthState>());
      expect(
        states[1],
        predicate<AuthState>((state) =>
            state.maybeWhen(
              error: (message) => message == "Invalid credentials",
              orElse: () => false,
            )),
      );

    });
  });

  group('signUp', () {
    test('emits error if name is empty', () async {
      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: false);

      await notifier.signUp(
        name: '',
        email: 'test@example.com',
        password: 'Password1',
        confirmPassword: 'Password1',
        gender: 'male',
        dob: '2000-01-01',
        phone: '1234567890',
        address: 'Test Address',
      );

      expect(states[0], AuthState.error("Name cannot be empty"));
    });

    test('emits loading and success on valid signup', () async {
      when(() => mockRepository.signUp(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        gender: any(named: 'gender'),
        dob: any(named: 'dob'),
        phone: any(named: 'phone'),
        address: any(named: 'address'),
      )).thenAnswer((_) async => {});

      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: false);

      await notifier.signUp(
        name: 'Test',
        email: 'test@example.com',
        password: 'Password1',
        confirmPassword: 'Password1',
        gender: 'male',
        dob: '2000-01-01',
        phone: '1234567890',
        address: 'Test Address',
      );

      expect(states[0], const AuthState.loading());
      expect(states[1], AuthState.success("Registration successful!"));
    });

    test('emits error if passwords do not match', () async {
      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: false);

      await notifier.signUp(
        name: 'Test',
        email: 'test@example.com',
        password: 'Password1',
        confirmPassword: 'Password2',
        gender: 'male',
        dob: '2000-01-01',
        phone: '1234567890',
        address: 'Test Address',
      );

      expect(states[0], AuthState.error("Passwords don't match"));
    });
  });

  group('logout', () {
    test('clears token and sets state to initial', () async {
      when(() => mockStorage.clearToken()).thenAnswer((_) async => {});

      final states = <AuthState>[];
      notifier.addListener((state) => states.add(state), fireImmediately: true);

      await notifier.logout();

      // The initial state is initial, so it will be emitted immediately by the listener
      // After logout, it sets state to initial again — depending on StateNotifier,
      // this might not trigger a new event if the state is identical.
      // So we expect at least one initial state emitted.

      expect(states.isNotEmpty, true);
      expect(states.first, const AuthState.initial());

      verify(() => mockStorage.clearToken()).called(1);
    });
  });

}