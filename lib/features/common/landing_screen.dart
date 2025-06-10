import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Top Left: InternLink Logo Title
            Positioned(
              top: 16,
              left: 16,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Intern', style: TextStyle(color: Colors.blue)),
                    TextSpan(text: 'Link', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),

            // Top Right: Login Button
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/waiting?next=login');
                  Future.delayed(const Duration(seconds: 2), () {
                    context.go('/waiting', extra: '/login');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login'),
              ),
            ),

            // Center Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Image
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 24),

                  // Slogan
                  const Text(
                    'Connecting Talent with Opportunity.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      context.go('/signup');
                    },

                    // onPressed: () {
                    //   context.go('/waiting?next=signup');
                    //   Future.delayed(const Duration(seconds: 2), () {
                    //     context.go('/waiting', extra: '/signup');
                    //   });
                    // },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}