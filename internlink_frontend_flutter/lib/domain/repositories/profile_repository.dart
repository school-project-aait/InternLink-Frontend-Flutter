import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<void> deleteProfile(int id);
}
