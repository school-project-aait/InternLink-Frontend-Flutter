import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/application.dart';

import '../providers/application_list_provider.dart';
import '../providers/application_list_state.dart';
import '../widgets/application_card.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  static const routeName = 'applications';
  static const routePath = '/student/applications';

  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(applicationListProvider.notifier).loadApplications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationListProvider);
    final notifier = ref.read(applicationListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refresh(),
            tooltip: 'Refresh applications',
          ),
        ],
      ),
      body: _buildBody(state, notifier),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToInternshipList(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ApplicationListState state, ApplicationListNotifier notifier) {
    return state.applications.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message, _) => _buildErrorView(message, notifier),
      success: (applications) => _buildApplicationsList(applications, notifier),
    );
  }

  Widget _buildErrorView(String message, ApplicationListNotifier notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => notifier.loadApplications(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList(
      List<Application> applications, ApplicationListNotifier notifier) {
    if (applications.isEmpty) {
      return const Center(
        child: Text(
          'No applications found\nApply to internships to see them here',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: applications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final application = applications[index];
          return ApplicationCard(
            application: application,
            onUpdate: () => _navigateToUpdateApplication(context, application),
            onDelete: () => _confirmDelete(context, notifier, application),
          );
        },
      ),
    );
  }

  void _navigateToInternshipList(BuildContext context) {
    context.go('/student/internships');
  }

  void _navigateToUpdateApplication(BuildContext context, Application application) {
    context.push(
      Uri(
        path: '/student/applications/${application.internshipId}',
        queryParameters: {
          'isUpdate': 'true',
          'applicationId': application.id.toString(),
          'university': application.university,
          'degree': application.degree,
          'graduationYear': application.graduationYear.toString(),
          'linkedIn': application.linkedIn,
        },
      ).toString(),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context,
      ApplicationListNotifier notifier,
      Application application,
      ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Application'),
        content: const Text(
            'Are you sure you want to withdraw this application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Withdraw',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.deleteApplication(application.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application withdrawn successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}