import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_frontend_flutter/core/exceptions/auth_exception.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../providers.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(secureStorageProvider),
  );
});
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorage _secureStorage;

  AuthNotifier(this._repository, this._secureStorage) : super(const AuthState.initial());

  bool _isPasswordValid(String password) {
    final pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$';
    return RegExp(pattern).hasMatch(password);
  }

  bool _isValidDate(String dateString) {
    try {
      DateFormat('yyyy-MM-dd').parseStrict(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(email, password);
      await _secureStorage.saveToken(user.token);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _secureStorage.clearToken();
    state = const AuthState.initial();
  }

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
    if (name.isEmpty) {
      state = AuthState.error("Name cannot be empty");
      return;
    }
    if (email.isEmpty) {
      state = AuthState.error("Email cannot be empty");
      return;
    }
    if (password.isEmpty) {
      state = AuthState.error("Password cannot be empty");
      return;
    }
    if (password != confirmPassword) {
      state = AuthState.error("Passwords don't match");
      return;
    }
    if (!_isPasswordValid(password)) {
      state = AuthState.error("Password must contain 8+ chars with uppercase, lowercase and number");
      return;
    }
    if (!_isValidDate(dob)) {
      state = AuthState.error("Invalid date format. Use YYYY-MM-DD");
      return;
    }
    if (phone.isEmpty) {
      state = AuthState.error("Phone cannot be empty");
      return;
    }
    if (address.isEmpty) {
      state = AuthState.error("Address cannot be empty");
      return;
    }

    state = AuthState.loading();
    try {
      await _repository.signUp(
        name: name,
        email: email,
        password: password,
        gender: gender,
        dob: dob,
        phone: phone,
        address: address,
      );
      state = const AuthState.initial(); // You can show success message if needed
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error("Registration failed. Please try again.");
    }
  }

  void clearState() {
    state = const AuthState.initial();
  }
}



