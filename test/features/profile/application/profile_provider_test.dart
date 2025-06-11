import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/user_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/delete_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/get_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/update_profile.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/profile_provider.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/profile_repository_provider.dart'
    as repo;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_provider_test.mocks.dart';

// Generate mocks for use cases
@GenerateMocks([GetProfile, UpdateProfile, DeleteProfile])
void main() {
  late MockGetProfile mockGetProfile;
  late MockUpdateProfile mockUpdateProfile;
  late MockDeleteProfile mockDeleteProfile;
  late ProviderContainer container;

  final mockProfile = UserProfile(
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    phone: '1234567890',
    address: '123 Street',
    gender: 'male',
  );

  setUp(() {
    mockGetProfile = MockGetProfile();
    mockUpdateProfile = MockUpdateProfile();
    mockDeleteProfile = MockDeleteProfile();

    // Override providers with mocks
    container = ProviderContainer(
      overrides: [
        repo.getProfileUsecaseProvider.overrideWithValue(mockGetProfile),
        repo.updateProfileUsecaseProvider.overrideWithValue(mockUpdateProfile),
        repo.deleteProfileUsecaseProvider.overrideWithValue(mockDeleteProfile),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('loadProfile sets state to AsyncData with profile on success', () async {
    when(mockGetProfile()).thenAnswer((_) async => mockProfile);

    // Create notifier manually
    final notifier = ProfileNotifier(
      mockGetProfile,
      mockUpdateProfile,
      mockDeleteProfile,
    );

    await notifier.loadProfile();

    // Expect AsyncData<UserProfile?> instead of AsyncData<UserProfile>
    expect(notifier.state, AsyncData<UserProfile?>(mockProfile));
  });

  test(
    'update updates the profile and sets state to AsyncData with updated profile',
    () async {
      when(mockUpdateProfile(any)).thenAnswer((_) async => mockProfile);

      final notifier = ProfileNotifier(
        mockGetProfile,
        mockUpdateProfile,
        mockDeleteProfile,
      );

      await notifier.update(mockProfile);

      // Expect AsyncData<UserProfile?> instead of AsyncData<UserProfile>
      expect(notifier.state, AsyncData<UserProfile?>(mockProfile));
    },
  );

  test(
    'delete deletes the profile and sets state to AsyncData with null',
    () async {
      when(mockDeleteProfile(any)).thenAnswer((_) async => null);

      final notifier = ProfileNotifier(
        mockGetProfile,
        mockUpdateProfile,
        mockDeleteProfile,
      );

      // Pre-set state to a profile with id
      notifier.state = AsyncData<UserProfile?>(mockProfile);

      await notifier.delete();

      // Expect AsyncData<UserProfile?> with null value (not AsyncData<Null>)
      expect(notifier.state, const AsyncData<UserProfile?>(null));
    },
  );
}
