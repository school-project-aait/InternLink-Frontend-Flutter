import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/application.dart';
import '../../domain/usecases/check_existing_application.dart';

import '../../domain/usecases/create_application.dart';
// import '../../domain/usecases/check_existing_application.dart';
import 'application_state.dart';

class ApplicationNotifier extends StateNotifier<ApplicationFormState> {
  final CreateApplication _createApplication;
  final CheckExistingApplication _checkExistingApplication;
  final Ref _ref;

  ApplicationNotifier(
      this._createApplication,
      this._checkExistingApplication,
      this._ref,
      ) : super(ApplicationFormState());

  void setInternshipId(int id) {
    state = state.copyWith(
      internshipId: id,
      // Reset existing application check when internship changes
      hasExistingApplication: false,
    );
  }

  void setUniversity(String value) {
    state = state.copyWith(university: value);
  }

  void setDegree(String value) {
    state = state.copyWith(degree: value);
  }

  void setGraduationYear(String value) {
    state = state.copyWith(graduationYear: value);
  }

  void setLinkedIn(String value) {
    state = state.copyWith(linkedIn: value);
  }

  void setResume(String filePath, String fileName) {
    state = state.copyWith(filePath: filePath, fileName: fileName);
  }

  void clearErrors() {
    state = state.copyWith(fieldErrors: {});
  }

  void setFieldError(String field, String message) {
    state = state.copyWith(
      fieldErrors: {...state.fieldErrors, field: message},
    );
  }

  void clearFieldError(String field) {
    final newErrors = {...state.fieldErrors};
    newErrors.remove(field);
    state = state.copyWith(fieldErrors: newErrors);
  }

  Future<Resource<Application>> submitApplication() async {
    // Don't allow submission if application already exists
    if (state.hasExistingApplication) {
      return ResourceError('You have already applied to this internship');
    }

    // Validate first
    if (!state.isValid) {
      final errors = <String, String>{};
      if (state.university.isEmpty) errors['university'] = 'University is required';
      if (state.degree.isEmpty) errors['degree'] = 'Degree is required';
      if (state.graduationYear.isEmpty) errors['graduationYear'] = 'Graduation year is required';
      if (state.filePath == null) errors['resume'] = 'Resume is required';

      state = state.copyWith(fieldErrors: errors);
      return ResourceError('Please fill all required fields');
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final result = await _createApplication(
        internshipId: state.internshipId!,
        university: state.university,
        degree: state.degree,
        graduationYear: int.tryParse(state.graduationYear) ?? 0,
        linkedIn: state.linkedIn,
        filePath: state.filePath!,
      );

      if (result is ResourceSuccess<Application>) {
        // Clear form on success and mark as existing
        state = ApplicationFormState().copyWith(
          hasExistingApplication: true,
        );
        return result;
      }
      return result;
    } catch (e) {
      debugPrint('Application submission error: $e');
      return ResourceError('Failed to submit application: ${e.toString()}');
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  Future<void> checkExistingApplication() async {
    if (state.internshipId == null) {
      debugPrint('Cannot check - internshipId is null');
      return;
    }

    debugPrint('Checking existing application for internship: ${state.internshipId}');
    state = state.copyWith(isCheckingExisting: true);

    try {
      final result = await _checkExistingApplication(state.internshipId!);

      result.when(
        success: (exists) {
          debugPrint('Existing application check result: $exists');
          state = state.copyWith(
            hasExistingApplication: exists,
            isCheckingExisting: false,
          );
        },
        error: (message, error) {
          debugPrint('Error checking existing application: $message');
          // On error, assume no existing application to allow user to try
          state = state.copyWith(
            hasExistingApplication: false,
            isCheckingExisting: false,
          );
        },
        loading: () {},
      );
    } catch (e, stackTrace) {
      debugPrint('Unexpected error in checkExistingApplication: $e\n$stackTrace');
      state = state.copyWith(
        hasExistingApplication: false,
        isCheckingExisting: false,
      );
    }
  }

  // Optional: Add a method to reset the existing application flag
  void resetExistingApplicationCheck() {
    state = state.copyWith(hasExistingApplication: false);
  }
}

final applicationFormProvider = StateNotifierProvider<ApplicationNotifier, ApplicationFormState>((ref) {
  return ApplicationNotifier(
    ref.read(createApplicationProvider),
    ref.read(checkExistingApplicationProvider),
    ref,
  );
});