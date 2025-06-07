
import '../../../../core/utils/resource.dart';
import '../entities/internship.dart';
import '../repositories/internship_repository.dart';

class GetInternshipByIdUseCase {
  final InternshipRepository repository;

  GetInternshipByIdUseCase(this.repository);

  Future<Resource<Internship>> call(int id) async {
    return await repository.getInternshipById(id);
  }
}