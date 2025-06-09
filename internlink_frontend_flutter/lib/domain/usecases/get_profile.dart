import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';
import 'package:internlink_frontend_flutter/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repo;
  GetProfile(this.repo);
  Future<UserProfile> call() => repo.getProfile();
}
