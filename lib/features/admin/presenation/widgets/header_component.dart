import 'package:flutter/material.dart';

class HeaderComponent extends StatelessWidget {
  final VoidCallback onLogout;
  final String buttonText;

  const HeaderComponent({
    required this.onLogout,
    this.buttonText = 'Logout',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Intern',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blue[900],
              ),
            ),
            Text(
              'Link',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: onLogout,
          child: Text(buttonText),
        ),
      ],
    );
  }
}