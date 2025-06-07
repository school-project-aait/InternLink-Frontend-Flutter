
import '../../../../core/utils/resource.dart';
import '../entities/category.dart';
import '../repositories/internship_repository.dart';

class GetCategoriesUseCase {
  final InternshipRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Resource<List<Category>>> call() async {
    return await repository.getCategories();
  }
}