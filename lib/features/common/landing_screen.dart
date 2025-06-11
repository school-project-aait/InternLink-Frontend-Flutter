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
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 30, // Increased from 24
                    fontWeight: FontWeight.bold,
                    height: 1.2, // Better line spacing
                  ),
                  children: [
                    TextSpan(text: 'Intern', style: TextStyle(color: Colors.blue[900])),
                    const TextSpan(text: 'Link', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),

            // Top Right: Login Button - navigate to Login_screen
            Positioned(
              top: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () => context.go('/login'), // Direct navigation
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12, // Increased vertical padding
                  ),
                  minimumSize: const Size(100, 50), // Minimum width & height
                  textStyle: const TextStyle(
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                  ),
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
                    onPressed: () => context.go('/signup'), // Direct navigation
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10), // Increased padding
                      minimumSize: const Size(200, 60), // Minimum width & height
                      textStyle: const TextStyle(
                        fontSize: 20, // Larger font size
                        fontWeight: FontWeight.bold, // Bolder text
                      ),
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