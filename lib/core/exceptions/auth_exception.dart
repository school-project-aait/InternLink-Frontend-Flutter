

import 'package:dio/dio.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  factory AuthException.fromDioError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      return AuthException(e.response?.data['message'] ?? 'Authentication failed');
    }
    return AuthException('Network error occurred');
  }

  @override
  String toString() => message;
}
