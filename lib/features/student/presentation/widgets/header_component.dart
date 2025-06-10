import 'package:flutter/material.dart';

class HeaderComponent extends StatelessWidget {
  final VoidCallback onLogout;
  final String buttonText;

  const HeaderComponent({
    Key? key,
    required this.onLogout,
    this.buttonText = "Logout",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Text(
                "Intern",
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF1B2A80),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Link",
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              fixedSize: const Size(150, 50),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
