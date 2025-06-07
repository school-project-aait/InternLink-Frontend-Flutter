
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
  });
// Add other CRUD operations as needed
}