// lib/components/student_status_row.dart

import 'package:flutter/material.dart';
import '../state/student_status_state.dart';
import 'status_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';
//
// class StudentStatusRow extends StatelessWidget {
//   final StudentStatus student;
//   final Function(String) onStatusChange;
//
//   const StudentStatusRow({
//     Key? key,
//     required this.student,
//     required this.onStatusChange,
//   }) : super(key: key);
//
//   Future<void> _launchResumeUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(flex: 1, child: Text(student.name)),
//             Expanded(flex: 1, child: Text(student.email)),
//             Expanded(
//               flex: 1,
//               child: GestureDetector(
//                 onTap: () => _launchResumeUrl(student.resumeUrl),
//                 child: Text('View Resume', style: TextStyle(color: Colors.blue)),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: StatusDropdown(
//                 selectedStatus: student.status,
//                 onStatusChange: onStatusChange,
//               ),
//             ),
//           ],
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
