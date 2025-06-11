import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/student/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:internlink_flutter_application/features/student/data/models/response/profile_dto.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../../core/mocks/mock_dio.mocks.dart';


void main() {
  late MockDio mockDio;
  late ProfileRemoteDataSource remoteDataSource;

  setUp(() {
    mockDio = MockDio();
    remoteDataSource = ProfileRemoteDataSource(mockDio);
  });

  const mockJson = {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "123456789",
    "address": "Test Address",
    "gender": "Male"
  };

  final profileDto = ProfileDto.fromJson(mockJson);

  group('ProfileRemoteDataSource', () {
    test('getProfile returns ProfileDto on success', () async {
      final response = Response(
        data: mockJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/profile'),
      );

      when(mockDio.get('/users/profile')).thenAnswer((_) async => response);

      final result = await remoteDataSource.getProfile();

      expect(result.id, equals(1));
      expect(result.name, equals("Test User"));
      expect(result.email, equals("test@example.com"));
    });

    test('updateProfile returns updated ProfileDto', () async {
      final response = Response(
        data: mockJson,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/users/1'),
      );

      when(mockDio.put('/users/1', data: anyNamed('data')))
          .thenAnswer((_) async => response);

      final result = await remoteDataSource.updateProfile(1, profileDto);

      expect(result.id, equals(1));
      expect(result.name, equals("Test User"));
    });

    test('deleteProfile calls Dio.delete correctly', () async {
      final response = Response(
        data: null,
        statusCode: 204,
        requestOptions: RequestOptions(path: '/users/1'),
      );

      when(mockDio.delete('/users/1')).thenAnswer((_) async => response);

      await remoteDataSource.deleteProfile(1);

      verify(mockDio.delete('/users/1')).called(1);
    });
  });
}
