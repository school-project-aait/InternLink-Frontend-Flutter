import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/application.dart';
import 'package:internlink_flutter_application/features/student/presentation/widgets/application_card.dart';



void main() {
  group('ApplicationCard Widget', () {
    testWidgets('displays application details correctly', (WidgetTester tester) async {
      final application = Application(
        id: 1,
        internshipId: 101,
        internshipTitle: 'Flutter Intern',
        companyName: 'Tech Co.',
        university: 'Addis Ababa University',
        graduationYear: 2025,
        linkedIn: 'https://linkedin.com/in/sample',
        status: 'pending', userId: 1, degree: 'Bsc', resumeId: 1,
      );

      var wasUpdated = false;
      var wasDeleted = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ApplicationCard(
                application: application,
                onUpdate: () => wasUpdated = true,
                onDelete: () => wasDeleted = true,
              ),
            ),
          ),
        ),
      );

      // Check texts
      expect(find.text('Flutter Intern'), findsOneWidget);
      expect(find.text('Tech Co.'), findsOneWidget);
      expect(find.text('Addis Ababa University'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('UPDATE'), findsOneWidget);
      expect(find.text('WITHDRAW'), findsOneWidget);

      // Tap update and delete buttons
      await tester.tap(find.text('UPDATE'));
      await tester.tap(find.text('WITHDRAW'));
      expect(wasUpdated, isTrue);
      expect(wasDeleted, isTrue);

      // Check status indicator color
      final indicator = tester.widget<Container>(
        find.byWidgetPredicate(
              (widget) =>
          widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).shape == BoxShape.circle,
        ),
      );
      final decoration = indicator.decoration as BoxDecoration;
      expect(decoration.color, equals(const Color(0xFFFFA000))); // Orange for pending
    });

    testWidgets('hides withdraw button when status is not pending', (WidgetTester tester) async {
      final application = Application(
        id: 2,
        internshipId: 102,
        internshipTitle: 'Backend Intern',
        companyName: 'Code Inc.',
        university: 'AAU',
        graduationYear: 2024,
        linkedIn: '',
        status: 'accepted', userId: 1, degree: 'Bsc', resumeId: 1,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ApplicationCard(
                application: application,
                onUpdate: () {},
                onDelete: () {},
              ),
            ),
          ),
        ),
      );

      // 'WITHDRAW' should not be visible
      expect(find.text('WITHDRAW'), findsNothing);
      expect(find.text('UPDATE'), findsOneWidget);
    });
  });
}
