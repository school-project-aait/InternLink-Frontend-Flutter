import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';
import 'package:internlink_frontend_flutter/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repo;
  UpdateProfile(this.repo);
  Future<UserProfile> call(UserProfile profile) => repo.updateProfile(profile);
}
