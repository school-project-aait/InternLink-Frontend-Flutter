import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/auth/data/datasource/remote/auth_remote_data_source.dart';
import 'package:internlink_flutter_application/features/auth/data/model/user_model.dart';
import 'package:internlink_flutter_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late AuthRepository repository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepository(mockRemoteDataSource);
  });

  group('login', () {
    test('returns User on success', () async {
      final user = User(
        id: '1',
        email: 'test@example.com',
        role: 'student',
        token: 'abc123',
      );

      when(() => mockRemoteDataSource.login('test@example.com', 'password'))
          .thenAnswer((_) async => user);

      final result = await repository.login('test@example.com', 'password');
      expect(result, user);
    });

    test('throws error on DioException', () async {
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'message': 'Invalid credentials'},
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      expect(
            () => repository.login('wrong', 'wrong'),
        throwsA(isA<String>()),
      );
    });
  });

  group('signUp', () {
    test('completes on success', () async {
      when(() => mockRemoteDataSource.signUp(
        name: any(named: 'name'),
        email: any(named: 'email'),
        password: any(named: 'password'),
        gender: any(named: 'gender'),
        dob: any(named: 'dob'),
        phone: any(named: 'phone'),
        address: any(named: 'address'),
      )).thenAnswer((_) async => {});

      expect(
        repository.signUp(
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