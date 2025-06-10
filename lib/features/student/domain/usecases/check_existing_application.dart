import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../data/repositories/application_repository_impl.dart';
import '../repositories/application_repository.dart';

class CheckExistingApplication {
  final ApplicationRepository repository;

  CheckExistingApplication(this.repository);

  Future<Resource<bool>> call(int internshipId) async {
    return await repository.checkExistingApplication(internshipId);
  }
}
final checkExistingApplicationProvider = Provider<CheckExistingApplication>((ref) {
  return CheckExistingApplication(ref.read(applicationRepositoryProvider));
});