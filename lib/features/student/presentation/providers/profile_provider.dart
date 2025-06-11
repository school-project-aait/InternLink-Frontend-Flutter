import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/user_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/delete_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/get_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/update_profile.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/profile_repository_provider.dart';

final updateProfileUsecaseProvider = Provider((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UpdateProfile(repo);
});

final deleteProfileUsecaseProvider = Provider((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return DeleteProfile(repo);
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final getProfile = ref.watch(getProfileUsecaseProvider);
  final updateProfile = ref.watch(updateProfileUsecaseProvider);
  final deleteProfile = ref.watch(deleteProfileUsecaseProvider);
  return ProfileNotifier(getProfile, updateProfile, deleteProfile);
});

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final DeleteProfile deleteProfile;


  ProfileNotifier(this.getProfile, this.updateProfile, this.deleteProfile)
      : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await getProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(UserProfile updatedProfile) async {
    state = const AsyncValue.loading();
    try {
      final result = await updateProfile(updatedProfile);
      state = AsyncValue.data(result);
      // No error thrown here - let the screen handle navigation
    } catch (e, st) {
      // state = AsyncValue.error(e, st);
      // rethrow; // Re-throw to let the UI handle it
    }
  }

  Future<void> delete() async {
    try {
      final id = state.value?.id;
      if (id != null) {
        await deleteProfile(id);
        state = const AsyncValue.data(null); // Deleted
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
