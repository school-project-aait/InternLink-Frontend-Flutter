

// lib/screens/status_determiner_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/header_component.dart';
import '../providers/student_status_provider.dart';
// import '../components/header_component.dart';
// import '../components/rounded_border_button.dart';
// import '../components/student_status_row.dart';
import '../widgets/rounded_border_button.dart';
import '../widgets/student_status_row.dart';

class StatusDeterminerScreen extends ConsumerWidget {
  final VoidCallback onLogout;
  final VoidCallback onBackToDashboard;

  const StatusDeterminerScreen({
    Key? key,
    required this.onLogout,
    required this.onBackToDashboard,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(studentStatusProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Student Status Review'),
      //   actions: [
      //     TextButton(
      //       onPressed: onLogout,
      //       child: const Text('Logout', style: TextStyle(color: Colors.white)),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                child:
                HeaderComponent()
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Spacer(),
                const Text(
                  'Student Status Review',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.indigo),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    const Row(
                      children: [
                        Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Resume', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    const Divider(height: 16),
                    // List section — wrap in SizedBox or shrink-wrap with ListView
                    if (uiState.students.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: uiState.students.length,
                        itemBuilder: (context, index) {
                          final student = uiState.students[index];
                          return StudentStatusRow(
                            student: student,
                            onStatusChange: (newStatus) {
                              ref.read(studentStatusProvider.notifier).updateStatus(student.id, newStatus);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundedBorderButtonForApplication(
              buttonText: 'Back to Dashboard',
              onPressed: onBackToDashboard,
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final uiState = ref.watch(studentStatusProvider);
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Student Status Reminder'),
  //       actions: [
  //         TextButton(onPressed: onLogout, child: Text('Logout', style: TextStyle(color: Colors.white))),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           // HeaderComponent alternative already handled in AppBar
  //           SizedBox(height: 16),
  //           Card(
  //             elevation: 8,
  //             child: Padding(
  //               padding: const EdgeInsets.all(16),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: const [
  //                       Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
  //                       Expanded(child: Text('Company', style: TextStyle(fontWeight: FontWeight.bold))),
  //                       Expanded(child: Text('Resume', style: TextStyle(fontWeight: FontWeight.bold))),
  //                       Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
  //                     ],
  //                   ),
  //                   Divider(height: 16),
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: uiState.students.length,
  //                       itemBuilder: (context, index) {
  //                         final student = uiState.students[index];
  //                         return StudentStatusRow(
  //                           student: student,
  //                           onStatusChange: (newStatus) {
  //                             ref.read(studentStatusProvider.notifier).updateStatus(student.id, newStatus);
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           RoundedBorderButtonForApplication(
  //             buttonText: 'Back to Dashboard',
  //             onPressed: onBackToDashboard,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

//
//
// import 'package:flutter/material.dart';
//
// class StatusDeterminerScreen extends StatelessWidget {
//   const StatusDeterminerScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Application Status'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Review Applications Status',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent,
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Placeholder text or widget for status content
//             const Text(
//               'Here you can review all the applications and their current status.',
//               style: TextStyle(fontSize: 16),
//             ),
//
//             const SizedBox(height: 20),
//
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Go back to previous screen
//               },
//               child: const Text('Back to Dashboard'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
