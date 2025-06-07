
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:internlink_frontend_flutter/core/utils/secure_storage.dart';
import '../../providers.dart';
import '../constants/api_endpoints.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await ref.read(secureStorageProvider).getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  return dio;
});