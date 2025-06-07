
import '../../../../core/utils/resource.dart';
import '../entities/category.dart';
import '../entities/internship.dart';

abstract class InternshipRepository {
  Future<Resource<List<Category>>> getCategories();

  Future<Resource<Internship>> createInternship({
    required String title,
    String? description,
    required String deadline,
    required String companyName,
    required int categoryId,
    required String categoryName, // Add this parameter
  });

  Future<Resource<List<Internship>>> getInternships();

  Future<Resource<Internship>> getInternshipById(int id);

  Future<Resource<bool>> updateInternship({
    required int id,
    String? title,
    String? description,
    String? deadline,
    String? companyName,
    int? categoryId,
    String? categoryName, // Optional for update
  });

  Future<Resource<bool>> deleteInternship(int id);
}