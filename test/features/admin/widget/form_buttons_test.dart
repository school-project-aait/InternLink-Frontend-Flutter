import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/form_buttons.dart';

void main() {
  testWidgets('FormButtons calls onSave and onCancel', (WidgetTester tester) async {
    bool saveCalled = false;
    bool cancelCalled = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormButtons(
          onSave: () => saveCalled = true,
          onCancel: () => cancelCalled = true,
        ),
      ),
    ));

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(cancelCalled, isTrue);

    await tester.tap(find.text('Create'));
    await tester.pump();
    expect(saveCalled, isTrue);
  });
}
