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

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    final errorMessage = authState.maybeWhen(
      error: (msg) => msg,
      orElse: () => null,
    );

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
          print('User logged in: ${user.toString()}');
          if (context.mounted) {
            context.go('/');
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and app title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Intern", style: TextStyle(fontSize: 40, color: Color(0xFF1B2A80))),
                  Text("Link", style: TextStyle(fontSize: 40, color: Color(0xFF2196F3))),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Login", style: TextStyle(fontSize: 35, color: Colors.blue)),
              const Text("Please login to continue", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),

              if (errorMessage != null) ...[
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 10),
              ],

              // Email input
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _login(ref),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(fontSize: 20)),
                ),
              ),

              const SizedBox(height: 24),

              // Sign up prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => context.go('/signup'),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final authState = ref.watch(authProvider);
  //
  //   // Check if in loading state
  //   final isLoading = authState.maybeWhen(
  //     loading: () => true,
  //     orElse: () => false,
  //   );
  //
  //   // Check if there's an error message
  //   final errorMessage = authState.maybeWhen(
  //     error: (msg) => msg,
  //     orElse: () => null,
  //   );
  //
  //   // ✅ Detect successful login (authenticated state)
  //   ref.listen(authProvider, (previous, next) {
  //     next.maybeWhen(
  //       authenticated: (user) {
  //         // Show login success message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Login successful')),
  //         );
  //
  //         // Print user domain to logcat
  //         print('User logged in: ${user.toString()}');
  //
  //         // Use GoRouter to navigate based on role
  //         if (context.mounted) {
  //           context.go('/'); // Let router handle redirection based on role
  //         }
  //       },
  //       orElse: () {},
  //     );
  //   });
  //
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Login')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: _emailController,
  //             decoration: const InputDecoration(labelText: 'Email'),
  //           ),
  //           TextField(
  //             controller: _passwordController,
  //             decoration: const InputDecoration(labelText: 'Password'),
  //             obscureText: true,
  //           ),
  //           const SizedBox(height: 20),
  //           ElevatedButton(
  //             onPressed: isLoading ? null : () => _login(ref),
  //             child: isLoading
  //                 ? const CircularProgressIndicator()
  //                 : const Text('Login'),
  //           ),
  //           if (errorMessage != null)
  //             Text(errorMessage, style: const TextStyle(color: Colors.red)),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void _login(WidgetRef ref) {
  //   ref.read(authProvider.notifier).login(
  //     _emailController.text.trim(),
  //     _passwordController.text.trim(),
  //   );
  // }
}