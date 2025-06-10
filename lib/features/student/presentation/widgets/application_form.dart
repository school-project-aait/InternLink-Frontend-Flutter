import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/FilePickerHelper.dart';
import '../providers/application_provider.dart';
import 'custom_text_field.dart';

class ApplicationForm extends ConsumerWidget {
  final int internshipId;
  final VoidCallback onSuccess;

  const ApplicationForm({
    super.key,
    required this.internshipId,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(applicationFormProvider);
    final notifier = ref.read(applicationFormProvider.notifier);

    // Set internship ID and check existing application on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.internshipId == null || state.internshipId != internshipId) {
        notifier.setInternshipId(internshipId);
        notifier.checkExistingApplication();
      }
    });

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Show loading indicator while checking for existing application
                if (state.isCheckingExisting)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CircularProgressIndicator(),
                  ),

                // Show message if application exists
                if (state.hasExistingApplication)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You have already applied to this internship',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Only show form if no existing application and not checking
                if (!state.hasExistingApplication && !state.isCheckingExisting) ...[
                  CustomTextField(
                    label: 'University',
                    value: state.university,
                    errorText: state.fieldErrors['university'],
                    onChanged: notifier.setUniversity,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Degree',
                    value: state.degree,
                    errorText: state.fieldErrors['degree'],
                    onChanged: notifier.setDegree,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Graduation Year',
                    value: state.graduationYear,
                    errorText: state.fieldErrors['graduation_year'],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final year = int.tryParse(value);
                      if (year != null && (year < 2000 || year > 2030)) {
                        notifier.setGraduationYear(value);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          notifier.setFieldError(
                              'graduation_year',
                              'Enter a valid year between 2000-2030'
                          );
                        });
                      } else {
                        notifier.setGraduationYear(value);
                        notifier.clearFieldError('graduation_year');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'LinkedIn Profile',
                    value: state.linkedIn,
                    errorText: state.fieldErrors['linkdIn'],
                    onChanged: (value) {
                      if (value.isNotEmpty && !value.contains('linkedin.com')) {
                        notifier.setLinkedIn(value);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          notifier.setFieldError(
                              'linkdIn',
                              'Enter a valid LinkedIn URL'
                          );
                        });
                      } else {
                        notifier.setLinkedIn(value);
                        notifier.clearFieldError('linkdIn');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () async {
                      final file = await FilePickerHelper.pickFile(['pdf', 'doc', 'docx']);
                      if (file != null) {
                        notifier.setResume(file.path!, file.name);
                        notifier.clearFieldError('resume');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file),
                          const SizedBox(width: 8),
                          Text(state.fileName ?? 'Upload Resume (PDF/DOC/DOCX)'),
                        ],
                      ),
                    ),
                  ),
                  if (state.fieldErrors['resume'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        state.fieldErrors['resume']!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () async {
                        notifier.clearErrors();

                        bool isValid = true;

                        if (state.university.isEmpty) {
                          notifier.setFieldError('university', 'University is required');
                          isValid = false;
                        }

                        if (state.degree.isEmpty) {
                          notifier.setFieldError('degree', 'Degree is required');
                          isValid = false;
                        }

                        final graduationYear = int.tryParse(state.graduationYear);
                        if (state.graduationYear.isEmpty) {
                          notifier.setFieldError('graduation_year', 'Graduation year is required');
                          isValid = false;
                        } else if (graduationYear == null || graduationYear < 2000 || graduationYear > 2030) {
                          notifier.setFieldError('graduation_year', 'Enter a valid year between 2000-2030');
                          isValid = false;
                        }

                        if (state.filePath == null) {
                          notifier.setFieldError('resume', 'Resume is required');
                          isValid = false;
                        }

                        if (state.linkedIn.isNotEmpty && !state.linkedIn.contains('linkedin.com')) {
                          notifier.setFieldError('linkdIn', 'Enter a valid LinkedIn URL');
                          isValid = false;
                        }

                        if (!isValid) return;

                        final result = await notifier.submitApplication();

                        result.when(
                          success: (data) => onSuccess(),
                          error: (message, _) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          loading: () {},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        'SUBMIT APPLICATION',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Show loading overlay for submission
        if (state.isSubmitting)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}