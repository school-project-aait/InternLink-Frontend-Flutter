// import 'package:flutter/material.dart';
//
// class RoundedBorderButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isLoading;
//
//   const RoundedBorderButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Theme.of(context).primaryColor,
//         backgroundColor: Colors.white,
//         side: BorderSide(
//           color: Theme.of(context).primaryColor,
//           width: 2,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//       onPressed: isLoading ? null : onPressed,
//       child: isLoading
//           ? const CircularProgressIndicator()
//           : Text(
//         text,
//         style: TextStyle(
//           color: Theme.of(context).primaryColor,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }