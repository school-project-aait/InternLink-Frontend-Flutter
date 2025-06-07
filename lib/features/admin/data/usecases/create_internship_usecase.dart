

import '../../../../core/utils/resource.dart';
import '../entities/internship.dart';
import '../repositories/internship_repository.dart';

class CreateInternshipUseCase {
  final InternshipRepository repository;

  CreateInternshipUseCase(this.repository);

  Future<Resource<Internship>> call({
    required String title,
    String? description,
    required String deadline,
    required String companyName,
    required int categoryId,
  }) async {
    return await repository.createInternship(
      title: title,
      description: description,
      deadline: deadline,
      companyName: companyName,
      categoryId: categoryId,
    );
  }
}