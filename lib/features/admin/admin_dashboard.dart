import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/secure_storage.dart'; // Adjust path if needed

class AdminDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final storage = ref.read(secureStorageProvider);
              await storage.clearToken();
              if (context.mounted) {
                context.go('/login');
              }
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome, Admin!'),
      ),
    );
  }
}
