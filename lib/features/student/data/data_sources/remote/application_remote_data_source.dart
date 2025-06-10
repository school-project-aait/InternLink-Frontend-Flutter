import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../providers.dart';
import '../../models/request/application_dto.dart';
import '../../models/request/application_list_dto.dart';
import '../../models/request/application_request_dto.dart';
import '../../models/request/application_update_dto.dart';
// import '../../models/response/application_list_dto.dart';

abstract class ApplicationRemoteDataSource {
  Future<ApplicationDto> createApplication({
    required ApplicationRequestDto applicationRequest,
    required String filePath,
  });
  Future<List<ApplicationListDto>> getUserApplications();
  Future<ApplicationDto> getApplicationById(int id);
  Future<bool> updateApplication(
      int id,
      ApplicationUpdateDto updates, {
        String? filePath,
      });
  Future<bool> deleteApplication(int id);
  Future<bool> checkExistingApplication(int internshipId);
}

class ApplicationRemoteDataSourceImpl implements ApplicationRemoteDataSource {
  final Dio dio;

  ApplicationRemoteDataSourceImpl(this.dio);

  @override
  Future<ApplicationDto> createApplication({
    required ApplicationRequestDto applicationRequest,
    required String filePath,
  }) async {
    // Convert the request to JSON first
    final requestJson = applicationRequest.toJson();

    // Create form data with proper field names
    final formData = FormData.fromMap({
      ...requestJson,
      'resume': await MultipartFile.fromFile(filePath, filename: 'resume.pdf'),
    });

    try {
      final response = await dio.post(
        ApiEndpoints.createApplication,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      // Handle the actual backend response structure
      if (response.data['success'] == true) {
        return ApplicationDto.fromJson({
          ...response.data,
          'application_id': response.data['applicationId'],
        });
      } else {
        throw Exception(response.data['error'] ?? 'Failed to create application');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['error'] ?? e.message);
      }
      throw Exception(e.message ?? 'Failed to create application');
    }
  }
  @override
  Future<List<ApplicationListDto>> getUserApplications() async {
    final response = await dio.get(ApiEndpoints.getUserApplications);
    return (response.data['data'] as List)
        .map((json) => ApplicationListDto.fromJson(json))
        .toList();
  }

  @override
  Future<ApplicationDto> getApplicationById(int id) async {
    final response = await dio.get('${ApiEndpoints.getSingleApplication}/$id');
    return ApplicationDto.fromJson(response.data['data']);
  }

  @override
  Future<bool> updateApplication(
      int id,
      ApplicationUpdateDto updates, {
        String? filePath,
      }) async {
    final formData = FormData.fromMap({
      ...updates.toJson(),
      if (filePath != null)
        'resume': await MultipartFile.fromFile(filePath, filename: 'resume.pdf'),
    });

    final response = await dio.put(
      '${ApiEndpoints.updateApplication}/$id',
      data: formData,
    );

    return response.data['success'];
  }


  @override
  Future<bool> deleteApplication(int id) async {
    final response = await dio.delete('${ApiEndpoints.deleteApplication}/$id');
    return response.data['success'];
  }
  @override
  Future<bool> checkExistingApplication(int internshipId) async {
    try {
      final response = await dio.get('/applications/check-existing',
          queryParameters: {'internship_id': internshipId}
      );
      return response.data['exists'] as bool;
    } catch (e) {
      throw Exception('Failed to check existing application: $e');
    }
  }

}

final applicationRemoteDataSourceProvider = Provider<ApplicationRemoteDataSource>(
      (ref) => ApplicationRemoteDataSourceImpl(ref.read(dioClientProvider)),
);