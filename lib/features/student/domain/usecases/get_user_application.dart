// get_user_applications_usecase.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../domain/entities/application.dart';
import '../../domain/repositories/application_repository.dart';

class GetUserApplications {
  final ApplicationRepository _repository;

  GetUserApplications(this._repository);

  Future<Resource<List<Application>>> call() async {
    return await _repository.getUserApplications();
  }
}

final getUserApplicationsProvider = Provider<GetUserApplications>((ref) {
  return GetUserApplications(ref.read(applicationRepositoryProvider));
});