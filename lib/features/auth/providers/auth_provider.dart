import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers.dart';
import '../data/repositories/auth_repository_impl.dart';
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
}