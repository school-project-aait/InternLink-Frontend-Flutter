import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../data/datasources/remote/profile_remote_data_source.dart';
import '../../../data/repositories/profile_repository_impl.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../domain/usecases/get_profile.dart';
import '../../../domain/usecases/update_profile.dart';
import '../../../domain/usecases/delete_profile.dart';

/// Base provider for the ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ProfileRemoteDataSource(
    Dio(
      BaseOptions(baseUrl: "http://localhost:8000"),
    ), // Adjust base URL if needed
  );
  return ProfileRepositoryImpl(remoteDataSource);
});

/// GetProfile UseCase provider
final getProfileUsecaseProvider = Provider<GetProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return GetProfile(repo);
});

/// UpdateProfile UseCase provider
final updateProfileUsecaseProvider = Provider<UpdateProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UpdateProfile(repo);
});

/// DeleteProfile UseCase provider
final deleteProfileUsecaseProvider = Provider<DeleteProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return DeleteProfile(repo);
});
