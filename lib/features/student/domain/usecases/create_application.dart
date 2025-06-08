// import 'package:dartz/dartz.dart';
// import 'package:internlink/core/errors/failures.dart';
// import 'package:internlink/features/applications/domain/entities/application.dart';
// import 'package:internlink/features/applications/domain/repositories/application_repository.dart';
//
// class CreateApplication {
//   final ApplicationRepository repository;
//
//   CreateApplication(this.repository);
//
//   Future<Either<Failure, Application>> call({
//     required int internshipId,
//     required String university,
//     required String degree,
//     required int graduationYear,
//     required String linkedIn,
//     required List<int> resumeFile,
//     required String fileName,
//   }) async {
//     return await repository.createApplication(
//       internshipId: internshipId,
//       university: university,
//       degree: degree,
//       graduationYear: graduationYear,
//       linkedIn: linkedIn,
//       resumeFile: resumeFile,
//       fileName: fileName,
//     );
//   }
// }