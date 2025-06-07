import '../../../../core/utils/resource.dart';
import '../repositories/internship_repository.dart';

class UpdateInternshipUseCase {
  final InternshipRepository repository;

  UpdateInternshipUseCase(this.repository);

  Future<Resource<bool>> call({
    required int id,
    String? title,
    String? description,
    String? deadline,
    String? companyName,
    int? categoryId,
    String? categoryName, // Added optional parameter
  }) async {
    return await repository.updateInternship(
      id: id,
      title: title,
      description: description,
      deadline: deadline,
      companyName: companyName,
      categoryId: categoryId,
      categoryName: categoryName, // Pass through the categoryName
    );
  }
}