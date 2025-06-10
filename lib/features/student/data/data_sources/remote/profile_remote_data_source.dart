import 'package:dio/dio.dart';
import '../../models/response/profile_dto.dart';
import '../../models/request/update_profile_request.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileDto> getProfile() async {
    final res = await dio.get('/users/profile');
    return ProfileDto.fromJson(res.data);
  }

  Future<ProfileDto> updateProfile(int id, ProfileDto dto) async {
    if (id == null) throw Exception("Profile ID cannot be null"); // Add null check

    final updateData = UpdateProfileRequest(
      name: dto.name ?? '', // Ensure non-null name
      phone: dto.phone,
      address: dto.address,
      gender: dto.gender,
    );

    final res = await dio.put('/users/$id', data: updateData.toJson());
    return ProfileDto.fromJson(res.data);
  }
  Future<void> deleteProfile(int id) async {
    await dio.delete('/users/$id');
  }
}