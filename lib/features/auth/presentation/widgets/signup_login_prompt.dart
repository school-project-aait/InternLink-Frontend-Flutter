import 'package:flutter/material.dart';
import 'package:internlink_frontend_flutter/features/auth/presentation/screens/login_screen.dart';

class SignupLoginPrompt extends StatelessWidget {
  const SignupLoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}