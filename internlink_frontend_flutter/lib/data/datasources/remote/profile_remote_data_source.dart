import 'package:dio/dio.dart';
import 'package:internlink_frontend_flutter/data/models/response/profile_dto.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileDto> getProfile() async {
    final res = await dio.get('/profile');
    return ProfileDto.fromJson(res.data);
  }

  Future<ProfileDto> updateProfile(int id, ProfileDto dto) async {
    final res = await dio.put('/profile/$id', data: dto.toJson());
    return ProfileDto.fromJson(res.data);
  }

  Future<void> deleteProfile(int id) async {
    await dio.delete('/profile/$id');
  }
}
