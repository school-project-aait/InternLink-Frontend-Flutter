
// features/auth/presentation/screens/signup_screen.dart
// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:internlink_frontend_flutter/core/utils/constants.dart';
// import 'package:internlink_frontend_flutter/features/auth/presentation/controllers/auth_notifier.dart';
// import 'package:internlink_frontend_flutter/features/auth/presentation/screens/login_screen.dart';
// import 'package:internlink_frontend_flutter/features/auth/providers/auth_provider.dart';
// import 'package:internlink_frontend_flutter/features/auth/providers/auth_state.dart';

import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Handle signup success
    ref.listen<AuthState>(authProvider, (_, state) {
      state.whenOrNull(
        authenticated: (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          ref.read(authProvider.notifier).clearState();
        },
      );
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Intern',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Link',
                  style: TextStyle(
                    fontSize: 40,
                    color:Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "Let's get started!",
              style: TextStyle(
                fontSize: 34,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Sign in prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  ),
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Form Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Name', 'Enter your Full name'),
                    const SizedBox(height: 12),
                    _buildTextField(_genderController, 'Gender', 'Male or Female'),
                    const SizedBox(height: 12),
                    _buildTextField(_dobController, 'Date of Birth', 'YYYY-MM-DD'),
                    const SizedBox(height: 12),
                    _buildTextField(_phoneController, 'Contact number', '+251912341211',
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildTextField(_addressController, 'Address', 'Enter your current address'),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Email', 'example@email.com',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _buildTextField(_passwordController, 'Enter Password', 'Create a strong password',
                        isPassword: true),
                    const SizedBox(height: 12),
                    _buildTextField(_confirmPasswordController, 'Confirm Password', 'Re-enter your password',
                        isPassword: true),
                    const SizedBox(height: 16),
                    // Sign up button
                    ElevatedButton(
                      onPressed: authState.maybeWhen(
                        loading: () => null,
                        orElse: () => _signUp,
                      ),
                      // onPressed: authState is _Loading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: authState.maybeWhen(
                        loading: () => const CircularProgressIndicator(color: Colors.white),
                        orElse: () => const Text('Sign up', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),

                      // child: authState is _Loading
                      //     ? const CircularProgressIndicator(color: Colors.white)
                      //     : const Text('Sign up', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String placeholder, {
        TextInputType keyboardType = TextInputType.text,
        bool isPassword = false,
      }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
    );
  }

  void _signUp() {
    ref.read(authProvider.notifier).signUp(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      gender: _genderController.text,
      dob: _dobController.text,
      phone: _phoneController.text,
      address: _addressController.text,
    );
  }
}











