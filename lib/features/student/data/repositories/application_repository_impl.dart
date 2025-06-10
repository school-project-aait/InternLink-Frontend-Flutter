import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/application.dart';
import '../../domain/repositories/application_repository.dart';
import '../data_sources/remote/application_remote_data_source.dart';
import '../models/request/application_dto.dart';
import '../models/request/application_list_dto.dart';
import '../models/request/application_request_dto.dart';
import '../models/request/application_update_dto.dart';
// import '../models/response/application_list_dto.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationRemoteDataSource remoteDataSource;

  ApplicationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Resource<Application>> createApplication({
    required int internshipId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    required String filePath,
  }) async {
    try {
      final applicationDto = await remoteDataSource.createApplication(
        applicationRequest: ApplicationRequestDto(
          internship_id: internshipId,
          university: university,
          degree: degree,
          graduationYear: graduationYear,
          linkedIn: linkedIn,
        ),
        filePath: filePath,
      );

      if (applicationDto == null) {
        return const ResourceError('Application data is null');
      }

      return ResourceSuccess(applicationDto.toDomain());
    } catch (e) {
      return ResourceError('Failed to create application: ${e.toString()}', e);
    }
  }

  @override
  Future<Resource<List<Application>>> getUserApplications() async {
    try {
      final applications = await remoteDataSource.getUserApplications();

      if (applications == null) {
        return const ResourceError('Application list is null');
      }


      return ResourceSuccess(
        applications.map((dto) => dto.toDomain()).toList(),
      );

    } catch (e) {
      return ResourceError('Failed to get applications: ${e.toString()}', e);
    }
  }

  @override
  Future<Resource<Application>> getApplicationById(int id) async {
    try {
      final application = await remoteDataSource.getApplicationById(id);

      if (application == null) {
        return const ResourceError('Application not found');
      }

      return ResourceSuccess(application.toDomain());
    } catch (e) {
      return ResourceError('Failed to get application: ${e.toString()}', e);
    }
  }

  @override
  Future<Resource<bool>> updateApplication({
    required int applicationId,
    required String university,
    required String degree,
    required int graduationYear,
    required String linkedIn,
    String? filePath,
  }) async {
    try {
      final success = await remoteDataSource.updateApplication(
        applicationId,
        ApplicationUpdateDto(
          university: university,
          degree: degree,
          graduationYear: graduationYear,
          linkedIn: linkedIn,
        ),
        filePath: filePath,
      );
      return ResourceSuccess(success);
    } catch (e) {
      return ResourceError('Failed to update application: ${e.toString()}', e);
    }
  }


  @override
  Future<Resource<bool>> deleteApplication(int applicationId) async {
    try {
      final success = await remoteDataSource.deleteApplication(applicationId);
      return ResourceSuccess(success);
    } catch (e) {
      return ResourceError('Failed to delete application: ${e.toString()}', e);
    }
  }
  @override
  Future<Resource<bool>> checkExistingApplication(int internshipId) async {
    // debugPrint('Checking existing application for internship: $internshipId');
    try {
      final exists = await remoteDataSource.checkExistingApplication(internshipId);
      // debugPrint('Existing application check result: $exists');
      // Handle potential null or unexpected responses
      return ResourceSuccess(exists == true);
    } catch (e, stackTrace) {
      // debugPrint('Error checking existing application: $e\n$stackTrace');
      // Return false on error to allow the user to try applying
      return ResourceError('Failed to check application status', e);
    }
  }
}


final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepositoryImpl(ref.read(applicationRemoteDataSourceProvider));
});

extension ApplicationDtoX on ApplicationDto {
  Application toDomain() => Application(
    id: application_id,
    userId: user_id,
    internshipId: internship_id,
    university: university,
    degree: degree,
    graduationYear: graduationYear,
    linkedIn: linkedIn,
    resumeId: resume_id,
    status: status ?? 'pending',
    internshipTitle: internship_title ?? '',
    companyName: company_name ?? '',
  );
}

extension ApplicationListDtoX on ApplicationListDto {
  Application toDomain() => Application(
    id: application_id,
    userId: user_id,
    internshipId: internship_id,
    university: university,
    degree: degree,
    graduationYear: graduationYear,
    linkedIn: linkedIn,
    resumeId: resume_id,
    status: status,
    internshipTitle: internship_title ?? '',
    companyName: company_name ?? '',
  );
}
