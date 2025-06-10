import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String value;
  final String? errorText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    this.errorText,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value.length),
    );
  }
}