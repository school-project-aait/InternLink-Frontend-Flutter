// lib/components/rounded_border_button.dart

import 'package:flutter/material.dart';

class RoundedBorderButtonForApplication extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool enabled;

  const RoundedBorderButtonForApplication({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          side: BorderSide(color: Colors.blue, width: 2),
          backgroundColor: Colors.white,
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: enabled ? Colors.blue : Colors.blue.withOpacity(0.5)),
        ),
      ),
    );
  }
}
