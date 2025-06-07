import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/constants/api_endpoints.dart';
import 'features/admin/data/repositories/internship_repository.dart';
import 'features/admin/data/usecases/create_internship_usecase.dart';
import 'features/admin/data/usecases/get_categories_usecase.dart';
import 'features/admin/domain/datasources/remote/internship_api_service.dart';
import 'features/admin/domain/repositories/internship_repository_impl.dart';
import 'features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

// Secure Storage Providers
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
  BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
));

// Dio Client with Interceptors Provider
final dioClientProvider = Provider<Dio>((ref) {
  final dio = ref.read(dioProvider);
  final secureStorage = ref.read(secureStorageProvider);

  // Add interceptors
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await secureStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        // Handle token refresh or logout here
      }
      return handler.next(error);
    },
  ));

  return dio;
});

// Auth Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authRemoteDataSourceProvider));
});

// Internship Providers
final internshipApiServiceProvider = Provider<InternshipApiService>((ref) {
  final dio = ref.read(dioClientProvider);
  return InternshipApiService(dio);
});

final internshipRepositoryProvider = Provider<InternshipRepository>((ref) {
  final apiService = ref.read(internshipApiServiceProvider);
  return InternshipRepositoryImpl(apiService);
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final createInternshipUseCaseProvider = Provider<CreateInternshipUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return CreateInternshipUseCase(repository);
});