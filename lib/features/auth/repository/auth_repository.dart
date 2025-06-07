


import 'package:dio/dio.dart';

import '../../../core/exceptions/auth_exception.dart';

// import '../domain/data_sources/remote/auth_remote_data_source.dart';
import '../data/datasource/remote/auth_remote_data_source.dart';
import '../data/model/user_model.dart';
// import '../domain/models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<User> login(String email, String password) async {
    try {
      return await _remoteDataSource.login(email, password);
    } on DioException catch (e) {
      throw AuthException.fromDioError(e);
    }
  }

// Future<User> registerStudent(String email, String password) async {
//   try {
//     return await _remoteDataSource.registerStudent(email, password);
//   } on DioException catch (e) {
//     throw AuthException.fromDioError(e);
//   }
// }
}