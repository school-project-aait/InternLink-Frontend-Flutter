import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_form.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProfileForm(
              profile: profile,
              onSave: (updatedProfile) {
                profileNotifier.update(updatedProfile);
              },
              onDelete: () {
                profileNotifier.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile deleted")),
                );
                context.go('/login');
              },
            ),
          );
        },
      ),
    );
  }
}
