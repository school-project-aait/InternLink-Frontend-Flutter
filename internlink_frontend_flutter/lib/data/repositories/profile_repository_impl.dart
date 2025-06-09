import 'package:internlink_frontend_flutter/data/datasources/remote/profile_remote_data_source.dart';
import 'package:internlink_frontend_flutter/data/models/response/profile_dto.dart';
import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';
import 'package:internlink_frontend_flutter/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserProfile> getProfile() async {
    final dto = await remote.getProfile();
    return dto.toEntity();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    final dto = ProfileDto.fromEntity(profile);
    return remote.updateProfile(profile.id, dto).then((res) => res.toEntity());
  }

  @override
  Future<void> deleteProfile(int id) => remote.deleteProfile(id);
}
