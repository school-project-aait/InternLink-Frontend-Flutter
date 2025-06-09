import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> getUserProfile() => remoteDataSource.getUserProfile();

  @override
  Future<void> updateUserProfile(User user) =>
      remoteDataSource.updateUserProfile(user as UserModel);

  @override
  Future<void> deleteUser() => remoteDataSource.deleteUser();
}
