import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/user_profile.dart';
import 'package:internlink_flutter_application/features/student/domain/repositories/profile_repository.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/profile_repository_provider.dart';
import 'package:internlink_flutter_application/features/student/presentation/screens/profile_screen.dart' as app;
import 'package:mocktail/mocktail.dart';
import 'package:integration_test/integration_test.dart';



class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Integration Test', () {
    late MockProfileRepository mockRepo;
    late UserProfile dummyProfile;

    setUp(() {
      mockRepo = MockProfileRepository();
      dummyProfile = UserProfile(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        address: '123 Street',
        gender: 'Male',
      );
    });

    testWidgets('Loads, updates, and deletes profile', (WidgetTester tester) async {
      // Arrange
      when(() => mockRepo.getProfile()).thenAnswer((_) async => dummyProfile);
      when(() => mockRepo.updateProfile(any())).thenAnswer((invocation) async => invocation.positionalArguments[0] as UserProfile);
      when(() => mockRepo.deleteProfile(any())).thenAnswer((_) async => Future.value());

      // Override providers with mock
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            profileRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child:  MaterialApp(home: app.ProfileScreen()),
        ),
      );

      await tester.pumpAndSettle(); // Wait for async operations

      // Assert that profile info loads
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('1234567890'), findsOneWidget);

      // Update name
      await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Jane Smith');
      await tester.tap(find.text('Update Profile'));
      await tester.pumpAndSettle();

      // Assert update success SnackBar
      expect(find.text("Profile updated"), findsOneWidget);
      verify(() => mockRepo.updateProfile(any(that: predicate<UserProfile>((p) => p.name == 'Jane Smith')))).called(1);

      // Delete profile
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert delete success SnackBar
      expect(find.text("Profile deleted"), findsOneWidget);
      verify(() => mockRepo.deleteProfile(1)).called(1);
    });
  });
}
