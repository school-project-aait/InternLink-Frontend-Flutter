import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserProfile();
  Future<void> updateUserProfile(User user);
  Future<void> deleteUser();
}
