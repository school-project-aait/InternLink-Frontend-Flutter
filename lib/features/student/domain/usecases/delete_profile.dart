import '../../domain/repositories/profile_repository.dart';

class DeleteProfile {
  final ProfileRepository repo;
  DeleteProfile(this.repo);
  Future<void> call(int id) => repo.deleteProfile(id);
}
