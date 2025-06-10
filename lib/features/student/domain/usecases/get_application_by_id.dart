// get_application_by_id_usecase.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../../domain/entities/application.dart';
import '../../domain/repositories/application_repository.dart';

class GetApplicationById {
  final ApplicationRepository _repository;

  GetApplicationById(this._repository);

  Future<Resource<Application>> call(int id) async {
    return await _repository.getApplicationById(id);
  }
}

final getApplicationByIdProvider = Provider<GetApplicationById>((ref) {
  return GetApplicationById(ref.read(applicationRepositoryProvider));
});