// lib/domain/repositories/student_status_repository.dart

// import 'package:internlink_flutter_application/domain/entities/student_status.dart';

import '../../presenation/state/student_status_state.dart';

abstract class StudentStatusRepository {
  Stream<List<StudentStatus>> getStudents();
  Future<void> updateStatus(int id, String status);
}
