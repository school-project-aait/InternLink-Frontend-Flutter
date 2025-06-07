import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isEditing;
  final bool isLoading;

  const FormButtons({
    Key? key,
    required this.onSave,
    required this.onCancel,
    this.isEditing = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: isLoading ? null : onSave,
          child: isLoading
              ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}