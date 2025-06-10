// delete_application_usecase.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../domain/repositories/application_repository.dart';

class DeleteApplication {
  final ApplicationRepository _repository;

  DeleteApplication(this._repository);

  Future<Resource<bool>> call(int applicationId) async {
    return await _repository.deleteApplication(applicationId);
  }
}

final deleteApplicationProvider = Provider<DeleteApplication>((ref) {
  return DeleteApplication(ref.read(applicationRepositoryProvider));
});