import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/api_endpoints.dart';
import 'core/utils/dio_client.dart';
import 'core/utils/secure_storage.dart';
import 'data/data_sources/remote/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
// import 'data/datasources/remote/auth_remote_data_source.dart';
// import 'data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'core/utils/secure_storage.dart';
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
// Dio Provider
final dioProvider = Provider<Dio>((ref) => Dio(
    BaseOptions(baseUrl: ApiEndpoints.baseUrl)
));

// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authRemoteDataSourceProvider));
});

// Secure Storage Provider
// final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());