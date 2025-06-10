import 'package:flutter/material.dart';

import '../../domain/entities/application_request.dart';

class ApplicationFormState {
  final int? internshipId;
  final String university;
  final String degree;
  final String graduationYear;
  final String linkedIn;
  final String? filePath;
  final String? fileName;
  final Map<String, String> fieldErrors;
  final bool isSubmitting;
  final bool isCheckingExisting; // Add this
  final bool hasExistingApplication; // Add this

  ApplicationFormState({
    this.internshipId,
    this.university = '',
    this.degree = '',
    this.graduationYear = '',
    this.linkedIn = '',
    this.filePath,
    this.fileName,
    this.fieldErrors = const {},
    this.isSubmitting = false,
    this.isCheckingExisting = false, // Add this
    this.hasExistingApplication = false,
  });

  ApplicationFormState copyWith({
    int? internshipId,
    String? university,
    String? degree,
    String? graduationYear,
    String? linkedIn,
    String? filePath,
    String? fileName,
    Map<String, String>? fieldErrors,
    bool? isSubmitting,
    bool? isCheckingExisting, // Add this
    bool? hasExistingApplication,
  }) {
    return ApplicationFormState(
      internshipId: internshipId ?? this.internshipId,
      university: university ?? this.university,
      degree: degree ?? this.degree,
      graduationYear: graduationYear ?? this.graduationYear,
      linkedIn: linkedIn ?? this.linkedIn,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCheckingExisting: isCheckingExisting ?? this.isCheckingExisting, // Add this
      hasExistingApplication: hasExistingApplication ?? this.hasExistingApplication,
    );
  }

  ApplicationRequest toRequest() {
    return ApplicationRequest(
      internshipId: internshipId!,
      university: university,
      degree: degree,
      graduationYear: int.tryParse(graduationYear) ?? 0,
      linkedIn: linkedIn,
    );
  }

  bool get isValid {
    return university.isNotEmpty &&
        degree.isNotEmpty &&
        graduationYear.isNotEmpty &&
        filePath != null &&
        internshipId != null;
  }
}