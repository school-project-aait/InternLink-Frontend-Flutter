import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/form_section.dart';

void main() {
  testWidgets('FormSection renders with title and child', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: FormSection(
          title: 'Test Section',
          child: Text('Section Content'),
        ),
      ),
    ));

    expect(find.text('Test Section'), findsOneWidget);
    expect(find.text('Section Content'), findsOneWidget);
  });
}
