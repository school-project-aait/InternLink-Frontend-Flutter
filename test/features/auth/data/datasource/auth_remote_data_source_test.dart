import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/core/constants/api_endpoints.dart';
import 'package:internlink_flutter_application/features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'package:internlink_flutter_application/features/auth/data/model/user_model.dart';
import 'package:mocktail/mocktail.dart';


class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late AuthRemoteDataSource dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSource(mockDio);
  });

  group('login', () {
    test('returns User on success', () async {
      final responsePayload = {
        'user': {
          'id': 1,
          'email': 'test@example.com',
          'role': 'student',
        },
        'token': 'abc123',
      };

      when(() => mockDio.post(
        ApiEndpoints.login,
        data: any(named: 'data'),
      )).thenAnswer((_) async => Response(
        data: responsePayload,
        statusCode: 200,
        requestOptions: RequestOptions(path: ApiEndpoints.login),
      ));

      final user = await dataSource.login('test@example.com', 'password');

      expect(user, isA<User>());
      expect(user.email, 'test@example.com');
      expect(user.token, 'abc123');
    });
  });

  group('signUp', () {
    test('completes on success', () async {
      when(() => mockDio.post(
        ApiEndpoints.signup,
        data: any(named: 'data'),
      )).thenAnswer((_) async => Response(
        data: {},
        statusCode: 201,
        requestOptions: RequestOptions(path: ApiEndpoints.signup),
      ));

      expect(
        dataSource.signUp(
          name: 'Test',
          email: 'test@example.com',
          password: 'Password1',
          gender: 'male',
          dob: '2000-01-01',
          phone: '1234567890',
          address: 'Test Address',
        ),
        completes,
      );
    });
  });
}