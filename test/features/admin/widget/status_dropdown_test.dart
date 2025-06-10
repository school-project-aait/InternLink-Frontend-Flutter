import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/status_dropdown.dart';

void main() {
  testWidgets('StatusDropdown shows selected status and changes on selection', (tester) async {
    String selectedStatus = 'Pending';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatusDropdown(
            selectedStatus: selectedStatus,
            onStatusChange: (newStatus) {
              selectedStatus = newStatus;
            },
          ),
        ),
      ),
    );

    expect(find.text('Pending'), findsOneWidget);

    // Tap dropdown to open menu
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    // Tap 'Accepted'
    await tester.tap(find.text('Accepted').last);
    await tester.pumpAndSettle();

    expect(selectedStatus, 'Accepted');
  });
}
