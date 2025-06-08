
import 'package:dio/dio.dart';
import 'package:internlink_frontend_flutter/core/exceptions/auth_exception.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../models/user_model.dart';

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

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String phone,
    required String address,
  }) async {
    try {
      await _remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        gender: gender,
        dob: dob,
        phone: phone,
        address: address,
      );
    } on DioException catch (e) {
      throw AuthException.fromDioError(e);
    }
  }
}