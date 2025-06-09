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
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // bigger tappable area
            textStyle: const TextStyle(
              fontSize: 18,       // larger font size
              fontWeight: FontWeight.bold,
              color: Colors.blue, // text color (although TextButton needs explicit color in style)
            ),
            foregroundColor: Colors.blue, // sets the text color properly
          ),
          onPressed: isLoading ? null : onCancel,
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // white background
            side: const BorderSide(color: Colors.blue, width: 2), // blue border
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // bigger size
            elevation: 0, // optional: no shadow
          ),
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