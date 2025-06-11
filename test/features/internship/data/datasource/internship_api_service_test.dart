// import 'package:flutter_test/flutter_test.dart';
// import 'package:internlink_flutter_application/core/constants/api_endpoints.dart';
// import 'package:internlink_flutter_application/features/admin/data/datasources/remote/internship_api_service.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dio/dio.dart';
//
// // import 'package:internlink_flutter_application/features/admin/data/services/internship_api_service.dart';
// import 'package:internlink_flutter_application/features/admin/domain/entities/category.dart';
// import 'package:internlink_flutter_application/core/utils/resource.dart';
//
// import '../../../../mocks.mocks.dart';
// import '../../../auth/data/datasource/auth_remote_data_source_test.dart';
//
// void main() {
//   final fullUrl = ApiEndpoints.baseUrl + ApiEndpoints.getDropdownData;
//   late InternshipApiService service;
//   late MockDio mockDio;
//
//   setUp(() {
//     mockDio = MockDio();
//     service = InternshipApiService(mockDio);
//   });
//
//   group('getCategories', () {
//     test('returns ResourceSuccess on valid response', () async {
//       // Arrange
//       final mockResponseData = {
//         "data": {
//           "categories": [
//             {"category_id": 1, "category_name": "Engineering"},
//             {"category_id": 2, "category_name": "Marketing"},
//           ]
//         }
//       };
//
//       when(mockDio.get(fullUrl)).thenAnswer(
//             (_) async => Response(
//           requestOptions: RequestOptions(path: fullUrl),
//           data: mockResponseData,
//           statusCode: 200,
//         ),
//       );
//
//       // Act
//       final result = await service.getCategories();
//
//       // Assert
//       expect(result, isA<ResourceSuccess<List<Category>>>());
//       final categories = (result as ResourceSuccess<List<Category>>).data;
//       expect(categories.length, 2);
//       expect(categories[0].name, 'Engineering');
//     });
//
//     test('returns ResourceError on DioException', () async {
//       // Arrange
//       when(mockDio.get(fullUrl)).thenThrow(
//         DioException(
//           requestOptions: RequestOptions(path: fullUrl),
//           type: DioExceptionType.connectionError,
//           error: 'No internet',
//         ),
//       );
//
//       // Act
//       final result = await service.getCategories();
//
//       // Assert
//       expect(result, isA<ResourceError>());
//       expect((result as ResourceError).message, contains('Failed to load categories'));
//     });
//   });
// }
