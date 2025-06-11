import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/delete_application.dart';
import 'package:internlink_flutter_application/features/student/domain/usecases/get_user_application.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/application_list_provider.dart';
import 'package:mockito/mockito.dart';

import 'package:internlink_flutter_application/core/utils/resource.dart';
import 'package:internlink_flutter_application/features/student/domain/entities/application.dart';
// import 'package:internlink_flutter_application/features/student/presentation/providers/application_list_notifier.dart';
import 'package:internlink_flutter_application/features/student/presentation/providers/application_list_state.dart';

import '../../../mocks.mocks.dart';

// import 'mocks.mocks.dart';

void main() {
  setUpAll(() {
    provideDummy<Resource<List<Application>>>(const ResourceLoading());
    provideDummy<Resource<bool>>(const ResourceLoading());
  });
  late MockGetUserApplications mockGetUserApplications;
  late MockDeleteApplication mockDeleteApplication;
  late ProviderContainer container;

  final mockApplications = [
    Application(
      id: 1,
      userId: 1,
      internshipId: 1,
      university: "Addis Ababa University",
      degree: "BSc in Software Engineering",
      graduationYear: 2025,
      linkedIn: "https://linkedin.com/in/student",
      resumeId: 10,
      status: 'pending',
      internshipTitle: "Mobile Developer Internship",
      companyName: "TechCorp",

    ),
  ];

  setUp(() {
    mockGetUserApplications = MockGetUserApplications();
    mockDeleteApplication = MockDeleteApplication();

    container = ProviderContainer(
      overrides: [
        getUserApplicationsProvider.overrideWithValue(mockGetUserApplications),
        deleteApplicationProvider.overrideWithValue(mockDeleteApplication),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('loadApplications sets ResourceSuccess state on success', () async {
    // Arrange
    when(mockGetUserApplications()).thenAnswer(
          (_) async => ResourceSuccess(mockApplications),
    );

    final notifier = container.read(applicationListProvider.notifier);

    // Wait for loadApplications in constructor
    await Future.delayed(const Duration(milliseconds: 100));

    final state = container.read(applicationListProvider);
    expect(state.applications, isA<ResourceSuccess<List<Application>>>());
    expect((state.applications as ResourceSuccess).data.length, 1);
  });

  test('deleteApplication calls delete and reloads on success', () async {
    // Arrange
    when(mockDeleteApplication(1)).thenAnswer(
          (_) async => const ResourceSuccess<bool>(true),
    );
    when(mockGetUserApplications()).thenAnswer(
          (_) async => ResourceSuccess(mockApplications),
    );

    final notifier = container.read(applicationListProvider.notifier);

    // Wait for loadApplications in constructor
    await Future.delayed(const Duration(milliseconds: 100));

    // Act
    await notifier.deleteApplication(1);

    // Assert
    verify(mockDeleteApplication(1)).called(1);
    verify(mockGetUserApplications()).called(greaterThanOrEqualTo(2)); // one from constructor + one from delete
  });
}
