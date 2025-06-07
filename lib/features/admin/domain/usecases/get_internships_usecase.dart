
import '../../../../core/utils/resource.dart';
import '../entities/internship.dart';
import '../repositories/internship_repository.dart';

class GetInternshipsUseCase {
  final InternshipRepository repository;

  GetInternshipsUseCase(this.repository);

  Future<Resource<List<Internship>>> call() async {
    return await repository.getInternships();
  }
}