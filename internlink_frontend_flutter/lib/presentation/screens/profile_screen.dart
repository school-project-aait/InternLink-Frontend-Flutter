import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_frontend_flutter/presentation/providers/profile_provider.dart';
import 'package:internlink_frontend_flutter/presentation/widgets/profile_form.dart';

@override
Widget build(BuildContext context, WidgetRef ref) {
  final profileState = ref.watch(profileProvider);
  final notifier = ref.read(profileProvider.notifier);

  return Scaffold(
    appBar: AppBar(title: const Text("Profile")),
    body: profileState.when(
      data: (profile) {
        if (profile == null) {
          return const Text("Profile deleted");
        }
        return ProfileForm(
          profile: profile,
          onSave: (updatedProfile) => notifier.update(updatedProfile),
          onDelete: () => notifier.delete(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error: $e")),
    ),
  );
}
