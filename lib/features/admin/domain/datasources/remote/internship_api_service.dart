import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../models/request/create_internship_request.dart';
import '../../models/response/category_response.dart';
import '../../models/response/internship_response.dart';

class InternshipApiService {
  final Dio dio;

  InternshipApiService(this.dio);

  Future<List<CategoryResponse>> getCategories() async {
    final response = await dio.get(
      '${ApiEndpoints.baseUrl}/internships/dropdown-data',
    );
    final data = response.data['data']['categories'] as List;
    return data.map((json) => CategoryResponse.fromJson(json)).toList();
  }

  Future<InternshipResponse> createInternship(
      CreateInternshipRequest request,
      ) async {
    final response = await dio.post(
      '${ApiEndpoints.baseUrl}/internships',
      data: request.toJson(),
    );
    return InternshipResponse.fromJson(response.data['data']);
  }
}