// update_application_usecase.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../domain/repositories/application_repository.dart';

class UpdateApplication {
  final ApplicationRepository _repository;

  UpdateApplication(this._repository);

  Future<Resource<bool>> call({
    required int applicationId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    String? filePath,
  }) async {
    return await _repository.updateApplication(
      applicationId: applicationId,
      university: university,
      degree: degree,
      graduationYear: graduationYear,
      linkedIn: linkedIn,
      filePath: filePath,
    );
  }
}

final updateApplicationProvider = Provider<UpdateApplication>((ref) {
  return UpdateApplication(ref.read(applicationRepositoryProvider));
});