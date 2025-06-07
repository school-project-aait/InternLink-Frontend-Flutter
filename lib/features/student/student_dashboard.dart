import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/secure_storage.dart'; // adjust the path if needed

class StudentDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final storage = ref.read(secureStorageProvider);
              await storage.clearToken();        // Clear token
              if (context.mounted) {
                context.go('/login');            // Navigate to login
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome, Student!'),
      ),
    );
  }
}
