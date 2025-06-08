import 'package:flutter/material.dart';

class InternshipListsScreen extends StatelessWidget {
  const InternshipListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Internships')),
      body: const Center(child: Text('List of Internships')),
    );
  }
}