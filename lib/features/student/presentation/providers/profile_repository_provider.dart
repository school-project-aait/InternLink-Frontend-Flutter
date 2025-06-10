import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:internlink_flutter_application/features/student/data/data_sources/remote/profile_remote_data_source.dart';

import '../../data/data_sources/remote/application_remote_data_source.dart';
import '../../data/repositories/profile_repostory_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/delete_profile.dart';

import '../../../../core/utils/dio_client.dart'; 


final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider); 
  final remoteDataSource = ProfileRemoteDataSource(dio);
  return ProfileRepositoryImpl(remoteDataSource);
});


final getProfileUsecaseProvider = Provider<GetProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return GetProfile(repo);
});


final updateProfileUsecaseProvider = Provider<UpdateProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UpdateProfile(repo);
});


final deleteProfileUsecaseProvider = Provider<DeleteProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return DeleteProfile(repo);
});
