import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:internlink_flutter_application/features/student/presentation/screens/student_dashboard.dart';
import '../widgets/application_form.dart';

class CreateApplicationScreen extends ConsumerWidget {
  static const routePath = '/student/applications/create/:internshipId';
  static const routeName = 'create_application';

  final int internshipId;

  const CreateApplicationScreen({
    super.key,
    required this.internshipId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Internship'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ApplicationForm(
        internshipId: internshipId,
        onSuccess: () {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to applications screen and remove all previous routes
          context.goNamed(
            ApplicationsScreen.routeName,
            // Remove all routes and make applications screen the root
            pathParameters: {'internshipId': internshipId.toString()},
          );
        },
      ),
    );
  }
}