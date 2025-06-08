// import 'package:dio/dio.dart';
//
// class ApplicationRepositoryImpl implements ApplicationRepository {
//   final ApplicationApiService apiService;
//
//   ApplicationRepositoryImpl(this.apiService);
//
//   @override
//   Future<int> createApplication({
//     required int internshipId,
//     required String university,
//     required String degree,
//     required int graduationYear,
//     required String linkedIn,
//     required List<int> resumeFile,
//     required String fileName,
//   }) async {
//     try {
//       final response = await apiService.createApplication(
//         internshipId: internshipId,
//         university: university,
//         degree: degree,
//         graduationYear: graduationYear,
//         linkedIn: linkedIn,
//         resumeFile: resumeFile,
//         fileName: fileName,
//       );
//
//       return response.data['applicationId']; // Direct return on success
//     } on DioException catch (e) {
//       throw ApplicationException(
//         e.response?.data['error'] ?? 'Failed to create application',
//       );
//     } catch (e) {
//       throw ApplicationException('Unexpected error: $e');
//     }
//   }
// }