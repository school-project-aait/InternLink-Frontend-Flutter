import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_frontend_flutter/features/applications/presentation/home_screen.dart';
import 'package:internlink_frontend_flutter/features/auth/presentation/widgets/login_form.dart';
import 'package:internlink_frontend_flutter/features/auth/presentation/widgets/signup_header.dart';
import 'package:internlink_frontend_flutter/features/auth/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);
    final errorMessage = authState.maybeWhen(error: (msg) => msg, orElse: () => null);

    ref.listen(authProvider, (_, next) {
      next.maybeWhen(
        authenticated: (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful')),
          );
          print('User logged in: ${user.toString()}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SignupHeader(),
            const SizedBox(height: 32),
            LoginForm(
              emailController: _emailController,
              passwordController: _passwordController,
              isLoading: isLoading,
              errorMessage: errorMessage,
              onLogin: () => _login(ref),
            ),
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