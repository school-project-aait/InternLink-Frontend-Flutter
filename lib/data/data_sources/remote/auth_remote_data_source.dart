import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../models/user_model.dart';


class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<User> login(String email, String password) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    // return User.fromJson(response.data);
    final data = response.data;

    return User(
      id: data['user']['id'].toString(), // Convert int to String
      email: data['user']['email'],
      role: data['user']['role'],
      token: data['token'],
    );
  }

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
    required String gender,
    required String dob,
    required String phone,
    required String address,
  }) async {
    final response = await dio.post(
      ApiEndpoints.signup,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
        'birth_date': dob,
        'phone': phone,
        'address': address,
      },
    );
    final data = response.data;
    return User(
      id: data['user']['id'].toString(),
      email: data['user']['email'],
      role: data['user']['role'] ?? 'student',
      token: data['token'],
    );
  }
}