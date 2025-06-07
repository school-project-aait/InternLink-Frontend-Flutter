import 'package:dio/dio.dart';

// import '../../../core/constants/api_endpoints.dart';
import '../../../../../core/constants/api_endpoints.dart';
import '../../model/user_model.dart';
// import '../../models/user_model.dart';


class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<User> login(String email, String password) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    // return User.fromJson(response.domain);
    final data = response.data;

    return User(
      id: data['user']['id'].toString(), // Convert int to String
      email: data['user']['email'],
      role: data['user']['role'],
      token: data['token'],
    );
  }
}