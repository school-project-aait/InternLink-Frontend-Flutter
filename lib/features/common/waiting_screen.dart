import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
