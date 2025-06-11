import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/rounded_border_button.dart';

void main() {
  testWidgets('RoundedBorderButtonForApplication shows text and responds to taps', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoundedBorderButtonForApplication(
            buttonText: 'Apply Now',
            onPressed: () {
              tapped = true;
            },
            enabled: true,
          ),
        ),
      ),
    );

    expect(find.text('Apply Now'), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('Button is disabled when enabled is false', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RoundedBorderButtonForApplication(
            buttonText: 'Apply Now',
            onPressed: () {
              tapped = true;
            },
            enabled: false,
          ),
        ),
      ),
    );

    expect(find.text('Apply Now'), findsOneWidget);

    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();

    expect(tapped, isFalse);
  });
}
