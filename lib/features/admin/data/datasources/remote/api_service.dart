// // lib/data/datasources/api_service.dart
// import 'package:dio/dio.dart';
// // import '../../core/constants/api_endpoints.dart';
// // import '../models/application_model.dart';
// // import '../models/update_status_request.dart';
//
// class ApiService {
//   final Dio dio;
//
//   ApiService(this.dio);
//
//   Future<List<ApplicationModel>> getApplications() async {
//     final response = await dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.getApplications}');
//     final List data = response.data['data'];
//     return data.map((json) => ApplicationModel.fromJson(json)).toList();
//   }
//
//   Future<void> updateApplicationStatus(int id, UpdateStatusRequest request) async {
//     await dio.patch(
//       '${ApiEndpoints.baseUrl}${ApiEndpoints.updateApplicationStatus(id)}',
//       data: request.toJson(),
//     );
//   }
// }
