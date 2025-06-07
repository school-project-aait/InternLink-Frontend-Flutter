

import '../../../../core/utils/resource.dart';
import '../repositories/internship_repository.dart';

class DeleteInternshipUseCase {
  final InternshipRepository repository;

  DeleteInternshipUseCase(this.repository);

  Future<Resource<bool>> call(int id) async {
    return await repository.deleteInternship(id);
  }
}