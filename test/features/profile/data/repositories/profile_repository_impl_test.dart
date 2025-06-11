import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/student/data/models/response/profile_dto.dart';
import 'package:internlink_flutter_application/features/student/data/repositories/profile_repostory_impl.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/user_profile.dart';
import 'package:mockito/mockito.dart';

import 'mock_profile_remote_data_source.mocks.dart';

// import 'package:your_app/features/profile/data/models/response/profile_dto.dart';
// import 'package:your_app/features/profile/domain/entities/user_profile.dart';
// import 'package:your_app/features/profile/data/repositories/profile_repository_impl.dart';
// import 'package:your_app/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
//
// import '../../../../core/mocks/mock_profile_remote_data_source.mocks.dart';

void main() {
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late ProfileRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemoteDataSource);
  });

  const mockJson = {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "phone": "123456789",
    "address": "Test Address",
    "gender": "Male"
  };

  final mockDto = ProfileDto.fromJson(mockJson);
  final mockEntity = mockDto.toEntity();

  group('ProfileRepositoryImpl', () {
    test('getProfile returns UserProfile from DTO', () async {
      when(mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => mockDto);

      final result = await repository.getProfile();

      expect(result, isA<UserProfile>());
      expect(result.id, equals(mockDto.id));
      expect(result.name, equals(mockDto.name));
      expect(result.email, equals(mockDto.email));
    });

    test('updateProfile calls remote and returns updated UserProfile', () async {
      when(mockRemoteDataSource.updateProfile(mockEntity.id, any))
          .thenAnswer((_) async => mockDto);

      final result = await repository.updateProfile(mockEntity);

      expect(result, isA<UserProfile>());
      expect(result.name, equals(mockDto.name));
    });

    test('deleteProfile calls remote deleteProfile correctly', () async {
      when(mockRemoteDataSource.deleteProfile(mockEntity.id))
          .thenAnswer((_) async => Future.value());

      await repository.deleteProfile(mockEntity.id);

      verify(mockRemoteDataSource.deleteProfile(mockEntity.id)).called(1);
    });
  });
}
