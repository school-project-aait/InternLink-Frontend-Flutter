// // lib/data/repositories/student_status_repository_impl.dart
//
// import 'dart:async';
//
// import 'package:internlink_flutter_application/core/constants/api_endpoints.dart';
//
// import '../../domain/entities/student_status.dart';
// import '../../domain/repositories/student_status_repository.dart';
//
// class StudentStatusRepositoryImpl implements StudentStatusRepository {
//   final ApiEndpoints apiService;
//
//   StudentStatusRepositoryImpl(this.apiService);
//
//   @override
//   Stream<List<StudentStatus>> getStudents() async* {
//     try {
//       final response = await apiService.getApplications;
//       if (response.success) {
//         final students = response.data.map((application) {
//           return StudentStatus(
//             id: application.id,
//             name: application.studentName,
//             email: application.companyName, // check if this is correct
//             resumeUrl: application.resumePath != null
//                 ? 'http://10.0.2.2:3000${application.resumePath!.replaceAll('\\', '/')}'
//                 : 'No resume',
//             status: application.status,
//           );
//         }).toList();
//         yield students;
//       } else {
//         yield [];
//       }
//     } catch (_) {
//       yield [];
//     }
//   }
//
//   @override
//   Future<void> updateStatus(int id, String status) async {
//     final request = UpdateStatusRequest(status: status);
//     await apiService.updateApplicationStatus(id, request);
//   }
// }
