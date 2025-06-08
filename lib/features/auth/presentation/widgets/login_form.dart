import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_frontend_flutter/features/auth/providers/auth_provider.dart';
import 'package:internlink_frontend_flutter/features/auth/presentation/widgets/auth_text_field.dart';

class LoginForm extends ConsumerWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    this.errorMessage,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        AuthTextField(
          controller: emailController,
          label: 'Email',
          placeholder: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: passwordController,
          label: 'Password',
          placeholder: 'Enter your password',
          isPassword: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : onLogin,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.indigo,
          ),
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Login',style: TextStyle(fontSize: 18, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.white,),),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}