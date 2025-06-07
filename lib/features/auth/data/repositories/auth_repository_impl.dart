

import 'package:dio/dio.dart';

// import '../data_sources/remote/auth_remote_data_source.dart';
import '../datasource/remote/auth_remote_data_source.dart';
import '../model/user_model.dart';
// import '../models/user_model.dart';


class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<User> login(String email, String password) async {
    try {
      final user = await _remoteDataSource.login(email, password);
      return user;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      return e.response?.data['message'] ?? 'Authentication failed';
    }
    return 'Network error occurred';
  }
}