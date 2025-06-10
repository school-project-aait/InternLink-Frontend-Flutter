
import '../../../../core/utils/resource.dart';
import '../../data/models/request/application_update_dto.dart';
import '../entities/application.dart';

abstract class ApplicationRepository {
  Future<Resource<Application>> createApplication({
    required int internshipId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    required String filePath,
  });
  Future<Resource<List<Application>>> getUserApplications();
  Future<Resource<Application>> getApplicationById(int id);
  Future<Resource<bool>> updateApplication({
    required int applicationId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    String? filePath,
  });
  Future<Resource<bool>> deleteApplication(int applicationId);
  Future<Resource<bool>> checkExistingApplication(int internshipId);

}