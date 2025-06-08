import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/constants/api_endpoints.dart';
import 'features/admin/data/datasources/remote/internship_api_service.dart';
import 'features/admin/data/repositories/internship_repository_impl.dart';
import 'features/admin/domain/repositories/internship_repository.dart';
import 'features/admin/domain/usecases/create_internship_usecase.dart';
import 'features/admin/domain/usecases/delete_internship_usecase.dart';
import 'features/admin/domain/usecases/get_categories_usecase.dart';
import 'features/admin/domain/usecases/get_internship_by_id_usecase.dart';
import 'features/admin/domain/usecases/get_internships_usecase.dart';
import 'features/admin/domain/usecases/update_internship_usecase.dart';
import 'features/admin/presenation/providers/internship_list_notifier_provider.dart';
import 'features/admin/presenation/providers/internship_notifier_provider.dart';
import 'features/admin/presenation/state/internship_list_state.dart';
import 'features/admin/presenation/state/internship_state.dart';
import 'features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';


// ==================== Core Providers ====================
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

// ==================== Auth Providers ====================
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authRemoteDataSourceProvider));
});

// ==================== Internship Data Layer Providers ====================
final internshipApiServiceProvider = Provider<InternshipApiService>((ref) {
  final dio = ref.read(dioClientProvider);
  return InternshipApiService(dio);
});

final internshipRepositoryProvider = Provider<InternshipRepository>((ref) {
  final apiService = ref.read(internshipApiServiceProvider);
  return InternshipRepositoryImpl(apiService);
});

// ==================== Internship Use Case Providers ====================
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

final createInternshipUseCaseProvider = Provider<CreateInternshipUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return CreateInternshipUseCase(repository);
});

final getInternshipsUseCaseProvider = Provider<GetInternshipsUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return GetInternshipsUseCase(repository);
});

final getInternshipByIdUseCaseProvider = Provider<GetInternshipByIdUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return GetInternshipByIdUseCase(repository);
});

final updateInternshipUseCaseProvider = Provider<UpdateInternshipUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return UpdateInternshipUseCase(repository);
});

final deleteInternshipUseCaseProvider = Provider<DeleteInternshipUseCase>((ref) {
  final repository = ref.read(internshipRepositoryProvider);
  return DeleteInternshipUseCase(repository);
});

// ==================== Presentation Layer Providers ====================
// Internship List Provider (for dashboard)
final internshipListProvider = StateNotifierProvider<InternshipListNotifier, InternshipListState>((ref) {
  return InternshipListNotifier(
    getInternshipsUseCase: ref.read(getInternshipsUseCaseProvider),
    deleteInternshipUseCase: ref.read(deleteInternshipUseCaseProvider),
  );
});

// Internship Form Provider (for add/edit screen)
final internshipProvider = StateNotifierProvider<InternshipNotifier, InternshipState>((ref) {
  return InternshipNotifier(
    createInternshipUseCase: ref.read(createInternshipUseCaseProvider),
    getCategoriesUseCase: ref.read(getCategoriesUseCaseProvider),
    getInternshipByIdUseCase: ref.read(getInternshipByIdUseCaseProvider),
    updateInternshipUseCase: ref.read(updateInternshipUseCaseProvider),
  );
});