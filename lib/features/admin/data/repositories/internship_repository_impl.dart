import 'package:dio/dio.dart';
import '../../../../core/utils/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/internship.dart';
import '../../domain/repositories/internship_repository.dart';
import '../datasources/remote/internship_api_service.dart';
import '../models/request/create_internship_request.dart';
import '../models/request/update_internship_request.dart';

class InternshipRepositoryImpl implements InternshipRepository {
  final InternshipApiService apiService;

  InternshipRepositoryImpl(this.apiService);

  @override
  Future<Resource<List<Category>>> getCategories() async {
    try {
      final response = await apiService.getDropdownData();

      // Handle the nested response structure
      final categoriesData = response['data']['categories'] as List;

      final categories = categoriesData.map((e) => Category(
        id: e['category_id'],
        name: e['category_name'],
      )).toList();

      return ResourceSuccess(categories);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return ResourceError('Could not find categories endpoint. Is the server running?', e);
      }
      return ResourceError('Failed to load categories: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }
  @override
  Future<Resource<Internship>> createInternship({
    required String title,
    String? description,
    required String deadline,
    required String companyName,
    required int categoryId,
    required String categoryName,
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
        description: response.description ?? '',
        deadline: response.deadline,
        companyName: response.companyName,
        categoryName: categoryName,
        createdByName: response.createdByName,
        createdAt: response.createdAt,
        status: response.status,
        isActive: response.isActive == 1,
      );
      return ResourceSuccess(internship);
    } on DioException catch (e) {
      return ResourceError('Failed to create internship: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }

  @override
  Future<Resource<List<Internship>>> getInternships() async {
    try {
      final response = await apiService.getAllInternships();
      final internships = response.map((e) => Internship(
        id: e.internshipId,
        title: e.title,
        description: e.description ?? '',
        deadline: e.deadline,
        companyName: e.companyName,
        categoryName: e.categoryName,
        createdByName: e.createdByName,
        createdAt: e.createdAt,
        status: e.status,
        isActive: e.isActive == 1,
      )).toList();
      return ResourceSuccess(internships);
    } on DioException catch (e) {
      return ResourceError('Failed to load internships: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }

  @override
  Future<Resource<Internship>> getInternshipById(int id) async {
    try {
      final response = await apiService.getInternshipById(id);
      final internship = Internship(
        id: response.internshipId,
        title: response.title,
        description: response.description ?? '',
        deadline: response.deadline,
        companyName: response.companyName,
        categoryName: response.categoryName,
        createdByName: response.createdByName,
        createdAt: response.createdAt,
        status: response.status,
        isActive: response.isActive == 1,
      );
      return ResourceSuccess(internship);
    } on DioException catch (e) {
      return ResourceError('Failed to load internship: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }

  @override
  Future<Resource<bool>> updateInternship({
    required int id,
    String? title,
    String? description,
    String? deadline,
    String? companyName,
    int? categoryId,
    String? categoryName,
  }) async {
    try {
      final request = UpdateInternshipRequest(
        title: title,
        description: description,
        deadline: deadline,
        companyName: companyName,
        categoryId: categoryId,
      );
      await apiService.updateInternship(id, request);
      return ResourceSuccess(true);
    } on DioException catch (e) {
      return ResourceError('Failed to update internship: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }

  @override
  Future<Resource<bool>> deleteInternship(int id) async {
    try {
      await apiService.deleteInternship(id);
      return ResourceSuccess(true);
    } on DioException catch (e) {
      return ResourceError('Failed to delete internship: ${e.message}', e);
    } catch (e) {
      return ResourceError('Unexpected error: $e', e);
    }
  }
}