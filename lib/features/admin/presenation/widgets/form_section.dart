import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final String title;
  final Widget child;

  const FormSection({
    required this.title,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}