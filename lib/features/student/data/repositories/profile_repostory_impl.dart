import '../data_sources/remote/profile_remote_data_source.dart';
import '../../data/models/response/profile_dto.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl(this.remote);

  @override
  Future<UserProfile> getProfile() async {
    final dto = await remote.getProfile();
    return dto.toEntity();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final dto = ProfileDto.fromEntity(profile);
    final updatedDto = await remote.updateProfile(profile.id, dto);
    return updatedDto.toEntity();
  }

  @override
  Future<void> deleteProfile(int id) => remote.deleteProfile(id);
}