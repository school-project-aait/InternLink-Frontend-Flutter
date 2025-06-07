import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const FormButtons({
    required this.onSave,
    required this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onSave,
          child: const Text('Submit'),
        ),
        OutlinedButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}