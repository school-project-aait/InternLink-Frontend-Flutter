import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../entities/application.dart';
import '../repositories/application_repository.dart';

class CreateApplication {
  final ApplicationRepository repository;

  CreateApplication(this.repository);

  Future<Resource<Application>> call({
    required int internshipId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    required String filePath,
  }) async {
    return await repository.createApplication(
      internshipId: internshipId,
      university: university,
      degree: degree,
      graduationYear: graduationYear,
      linkedIn: linkedIn,
      filePath: filePath,
    );
  }
}

final createApplicationProvider = Provider<CreateApplication>((ref) {
  return CreateApplication(ref.read(applicationRepositoryProvider));
});