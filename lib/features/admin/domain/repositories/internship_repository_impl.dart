import 'package:dio/dio.dart';
import '../../../../core/utils/resource.dart';
import '../../data/entities/category.dart';
import '../../data/entities/internship.dart';
import '../../data/repositories/internship_repository.dart';
import '../datasources/remote/internship_api_service.dart';
import '../models/request/create_internship_request.dart';

class InternshipRepositoryImpl implements InternshipRepository {
  final InternshipApiService apiService;

  InternshipRepositoryImpl(this.apiService);

  @override
  Future<Resource<List<Category>>> getCategories() async {
    try {
      final response = await apiService.getCategories();
      final categories = response.map((e) => Category(
        id: e.categoryId,
        name: e.categoryName,
      )).toList();
      return ResourceSuccess(categories); // Changed to ResourceSuccess
    } on DioException catch (e) {
      return ResourceError('Failed to load categories: ${e.message}', e); // Changed to ResourceError
    } catch (e) {
      return ResourceError('Unexpected error: $e', e); // Changed to ResourceError
    }
  }

  @override
  Future<Resource<Internship>> createInternship({
    required String title,
    String? description,
    required String deadline,
    required String companyName,
    required int categoryId,
  }) async {
    try {
      final request = CreateInternshipRequest(
        title: title,
        description: description,
        deadline: deadline,
        companyName: companyName,
        categoryId: categoryId,
      );
      final response = await apiService.createInternship(request);
      final internship = Internship(
        id: response.internshipId,
        title: response.title,
        description: response.description,
        deadline: response.deadline,
        companyName: response.companyName,
        categoryName: response.categoryName,
        createdByName: response.createdByName,
        createdAt: response.createdAt,
        status: response.status,
        isActive: response.isActive,
      );
      return ResourceSuccess(internship); // Changed to ResourceSuccess
    } on DioException catch (e) {
      return ResourceError('Failed to create internship: ${e.message}', e); // Changed to ResourceError
    } catch (e) {
      return ResourceError('Unexpected error: $e', e); // Changed to ResourceError
    }
  }
}