import 'package:flutter/material.dart';
import '../../data/data_sources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/delete_user.dart';

class UserProvider extends ChangeNotifier {
  final _repository = UserRepositoryImpl(UserRemoteDataSource());

  User? user;
  bool isLoading = false;

  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();
    user = await GetUserProfile(_repository).call();
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    await UpdateUserProfile(_repository).call(updatedUser);
    user = updatedUser;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await DeleteUser(_repository).call();
    user = null;
    notifyListeners();
  }
}
