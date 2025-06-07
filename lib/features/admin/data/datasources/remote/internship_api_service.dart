import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/utils/resource.dart';
import '../../../domain/entities/category.dart';
import '../../models/request/create_internship_request.dart';
import '../../models/request/update_internship_request.dart';
import '../../models/response/base_response.dart';
import '../../models/response/category_response.dart';
import '../../models/response/internship_response.dart';

class InternshipApiService {
  final Dio dio;

  InternshipApiService(this.dio);

  @override
  Future<Resource<List<Category>>> getCategories() async {
    print('[DEBUG] Attempting to fetch categories from: ${ApiEndpoints.baseUrl}${ApiEndpoints.getDropdownData}');
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.getDropdownData}',
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer ${user.token}', // Add if your endpoint requires auth
        //   },
        // ),
      );
      print('[DEBUG] Received response: ${response.statusCode}');
      print('[DEBUG] Response data: ${response.data}');

      final categories = (response.data['data']['categories'] as List)
          .map((e) => Category(id: e['category_id'], name: e['category_name']))
          .toList();

      return ResourceSuccess(categories);
    } on DioException catch (e) {
      print('[ERROR] DioException: ${e.type}');
      print('[ERROR] Status code: ${e.response?.statusCode}');
      print('[ERROR] Message: ${e.message}');
      print('[ERROR] Response: ${e.response?.data}');
      return ResourceError('Failed to load categories', e);
    }
  }

  Future<InternshipResponse> createInternship(CreateInternshipRequest request) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}/internships',
        data: request.toJson(),
      );

      if (response.data == null || response.data['domain'] == null) {
        throw Exception('Invalid API response structure - missing domain');
      }

      return InternshipResponse.fromJson(response.data['domain']);
    } on DioException catch (e) {
      _logDioError(e);
      rethrow;
    } catch (e) {
      print('Error in createInternship: $e');
      rethrow;
    }
  }

  Future<BaseResponse<InternshipResponse>> updateInternship(
      int id,
      UpdateInternshipRequest request,
      ) async {
    try {
      final response = await dio.put(
        '${ApiEndpoints.baseUrl}/internships/$id',
        data: request.toJson(),
      );

      if (response.data == null) {
        throw Exception('Empty API response');
      }

      return BaseResponse.fromJson(
        response.data,
            (json) => InternshipResponse.fromJson(json),
      );
    } on DioException catch (e) {
      _logDioError(e);
      rethrow;
    } catch (e) {
      print('Error in updateInternship: $e');
      rethrow;
    }
  }
  Future<Map<String, dynamic>> getDropdownData() async {
    final response = await dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getDropdownData}');
    return response.data;
  }

  Future<List<InternshipResponse>> getAllInternships() async {
    try {
      final response = await dio.get('${ApiEndpoints.baseUrl}/internships');

      if (response.data == null) {
        throw Exception('API returned null response');
      }

      final responseData = response.data;

      // Match your Jetpack Compose structure
      if (responseData is Map && responseData['data'] is List) {
        final internshipsList = responseData['data'] as List;
        return internshipsList.map((json) => InternshipResponse.fromJson(json)).toList();
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      _logDioError(e);
      rethrow;
    } catch (e) {
      print('Error in getAllInternships: $e');
      rethrow;
    }
  }

  Future<InternshipResponse> getInternshipById(int id) async {
    try {
      final response = await dio.get('${ApiEndpoints.baseUrl}/internships/$id');

      if (response.data == null || response.data['domain'] == null) {
        throw Exception('Invalid API response structure - missing domain');
      }

      return InternshipResponse.fromJson(response.data['domain']);
    } on DioException catch (e) {
      _logDioError(e);
      rethrow;
    } catch (e) {
      print('Error in getInternshipById: $e');
      rethrow;
    }
  }

  Future<bool> deleteInternship(int id) async {
    try {
      final response = await dio.delete('${ApiEndpoints.baseUrl}/internships/$id');

      if (response.data == null) {
        throw Exception('API returned null response');
      }

      return response.data['success'] ?? false;
    } on DioException catch (e) {
      _logDioError(e);
      rethrow;
    } catch (e) {
      print('Error in deleteInternship: $e');
      rethrow;
    }
  }

  // Helper method for Dio error logging
  void _logDioError(DioException e) {
    print('Dio Error:');
    print('- Message: ${e.message}');
    print('- Type: ${e.type}');
    print('- Response: ${e.response?.data}');
    print('- Status Code: ${e.response?.statusCode}');
    print('- Request: ${e.requestOptions.method} ${e.requestOptions.path}');
  }
}