import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/student_status_row.dart';
import 'package:internlink_flutter_application/features/admin/presenation/state/student_status_state.dart';

void main() {
  testWidgets('StudentStatusRow displays student info and changes status', (tester) async {
    final student = StudentStatus(
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      resumeUrl: 'https://example.com/resume.pdf',
      status: 'Pending',
    );

    String statusChangedTo = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StudentStatusRow(
            student: student,
            onStatusChange: (status) {
              statusChangedTo = status;
            },
          ),
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.text('View Resume'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);

    // Change status to Accepted
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accepted').last);
    await tester.pumpAndSettle();

    expect(statusChangedTo, 'Accepted');
  });
}
