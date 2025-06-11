import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/category_dropdown.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/category.dart';

void main() {
  testWidgets('CategoryDropdown renders and selects a category', (WidgetTester tester) async {
    final categories = [Category(id: 1, name: 'IT'), Category(id: 2, name: 'Marketing')];
    int? selectedId;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CategoryDropdown(
          categories: categories,
          selectedCategoryId: null,
          onCategorySelected: (id) => selectedId = id,
        ),
      ),
    ));

    expect(find.text('Select Category'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('IT').last);
    await tester.pumpAndSettle();

    expect(selectedId, 1);
  });
}
