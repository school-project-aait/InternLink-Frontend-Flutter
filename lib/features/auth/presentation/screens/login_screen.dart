import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Check if in loading state
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    // Check if there's an error message
    final errorMessage = authState.maybeWhen(
      error: (msg) => msg,
      orElse: () => null,
    );

    // ✅ Detect successful login (authenticated state)
    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          // Show login success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );

          // Print user data to logcat
          print('User logged in: ${user.toString()}');

          // Use GoRouter to navigate based on role
          if (context.mounted) {
            context.go('/'); // Let router handle redirection based on role
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : () => _login(ref),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
            if (errorMessage != null)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _login(WidgetRef ref) {
    ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }
}