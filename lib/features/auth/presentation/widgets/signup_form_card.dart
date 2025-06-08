import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_frontend_flutter/features/auth/providers/auth_state.dart';
import 'package:internlink_frontend_flutter/features/auth/presentation/widgets/auth_text_field.dart';
// import 'package:internlink_frontend_flutter/features/auth/presentation/widgets/au';
class SignupFormCard extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController dobController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final AuthState authState;
  final VoidCallback onSignUp;

  const SignupFormCard({
    super.key,
    required this.nameController,
    required this.genderController,
    required this.dobController,
    required this.phoneController,
    required this.addressController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.authState,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AuthTextField(
              controller: nameController,
              label: 'Name',
              placeholder: 'Enter your Full name',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: genderController,
              label: 'Gender',
              placeholder: 'Male or Female',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: dobController,
              label: 'Date of Birth',
              placeholder: 'YYYY-MM-DD',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: phoneController,
              label: 'Contact number',
              placeholder: '+251912341211',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: addressController,
              label: 'Address',
              placeholder: 'Enter your current address',
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: emailController,
              label: 'Email',
              placeholder: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: passwordController,
              label: 'Enter Password',
              placeholder: 'Create a strong password',
              isPassword: true,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: confirmPasswordController,
              label: 'Confirm Password',
              placeholder: 'Re-enter your password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: authState.maybeWhen(
                loading: () => null,
                orElse: () => onSignUp,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: authState.maybeWhen(
                loading: () => const CircularProgressIndicator(color: Colors.white),
                orElse: () => const Text('Sign up', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}