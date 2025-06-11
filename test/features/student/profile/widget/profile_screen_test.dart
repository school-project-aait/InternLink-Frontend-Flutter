import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/user_profile.dart';
import 'package:internlink_flutter_application/features/student/presentation/widgets/profile_form.dart';


void main() {
  group('ProfileForm Widget Tests', () {
    late UserProfile testProfile;
    late bool onSaveCalled;
    late UserProfile? savedProfile;
    late bool onDeleteCalled;

    setUp(() {
      testProfile = UserProfile(
        id: 123,
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        address: '123 Main St',
        gender: 'Male',
      );
      onSaveCalled = false;
      savedProfile = null;
      onDeleteCalled = false;
    });

    testWidgets('displays initial data correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileForm(
              profile: testProfile,
              onSave: (_) {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Check initial field values
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);
      expect(find.text('Male'), findsOneWidget);
    });

    testWidgets('calls onSave with updated data on Update Profile button press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileForm(
              profile: testProfile,
              onSave: (profile) {
                onSaveCalled = true;
                savedProfile = profile;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // Change the name field
      await tester.enterText(find.byType(TextField).at(0), 'Jane Smith');
      await tester.pump();

      // Tap the update button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update Profile'));
      await tester.pump();

      expect(onSaveCalled, isTrue);
      expect(savedProfile, isNotNull);
      expect(savedProfile!.name, 'Jane Smith');
      expect(savedProfile!.phone, '1234567890');
      expect(savedProfile!.address, '123 Main St');
      expect(savedProfile!.gender, 'Male');
      expect(savedProfile!.id, testProfile.id);
      expect(savedProfile!.email, testProfile.email);
    });

    testWidgets('shows SnackBar if profile id is null on Update Profile button press', (tester) async {
      final profileWithoutId = UserProfile(
        id: 1,
        name: 'No ID User',
        email: 'noid@example.com',
        phone: null,
        address: null,
        gender: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileForm(
              profile: profileWithoutId,
              onSave: (_) {
                onSaveCalled = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // Tap the update button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update Profile'));
      await tester.pump(); // Start animation for SnackBar
      await tester.pump(const Duration(seconds: 1)); // Show SnackBar

      expect(onSaveCalled, isFalse);
      expect(find.text('Cannot update profile without ID'), findsOneWidget);
    });

    testWidgets('calls onDelete when Delete button is pressed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileForm(
              profile: testProfile,
              onSave: (_) {},
              onDelete: () {
                onDeleteCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pump();

      expect(onDeleteCalled, isTrue);
    });
  });
}
