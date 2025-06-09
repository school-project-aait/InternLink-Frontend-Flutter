// lib/domain/usecases/get_students_usecase.dart

// import '../entities/student_status.dart';
import '../../presenation/state/student_status_state.dart';
import '../repositories/student_status_repository.dart';
// lib/features/admin/domain/entities/student_status.dart

class GetStudentsUseCase {
  final StudentStatusRepository repository;

  GetStudentsUseCase(this.repository);

  Stream<List<StudentStatus>> call() {
    return repository.getStudents();
  }
}
