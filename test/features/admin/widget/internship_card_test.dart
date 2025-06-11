import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/internship_card.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/internship.dart';

void main() {
  testWidgets('InternshipCard renders title and responds to actions', (WidgetTester tester) async {
    final internship = Internship(
      id: 1,
      title: 'Flutter Developer',
      categoryName: 'IT',
      companyName: 'TechCorp',
      deadline: '2025-12-31',
      status: 'Pending',
      createdAt: '',
      description: 'Experience with Dart and Flutter required', // <-- required
      createdByName: 'Admin',
      isActive: true,
    );

    bool tapped = false;
    bool edited = false;
    bool deleted = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: InternshipCard(
          internship: internship,
          onTap: () => tapped = true,
          onEdit: () => edited = true,
          onDelete: () => deleted = true,
        ),
      ),
    ));

    expect(find.text('Flutter Developer'), findsOneWidget);
    expect(find.text('Company: TechCorp'), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    await tester.pump();
    expect(tapped, isTrue);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();
    expect(edited, isTrue);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    expect(deleted, isTrue);
  });
}
