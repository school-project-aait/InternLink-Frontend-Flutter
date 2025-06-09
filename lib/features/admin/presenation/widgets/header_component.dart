import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/core/utils/secure_storage.dart';

class HeaderComponent extends StatelessWidget {
  final String buttonText;

  const HeaderComponent({
    this.buttonText = 'Logout',
    Key? key,
  }) : super(key: key);

  Future<void> _handleLogout(BuildContext context) async {
    final secureStorage = SecureStorage(); // Create instance
    await secureStorage.clearToken(); // Clear token
    if (context.mounted) {
      GoRouter.of(context).go('/login'); // Navigate to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Intern',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.blue[900],
              ),
            ),
            Text(
              'Link',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 130, // Wider button
          child: ElevatedButton(
            onPressed: () => _handleLogout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Blue background
              foregroundColor: Colors.white, // White text
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 18), // Bigger font
            ),
          ),
        ),
      ],
    );
  }
}