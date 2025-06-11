import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/resource.dart';
import '../../../admin/presenation/widgets/header_component.dart';
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
                child:
                HeaderComponent()
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'My Applications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 8),
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => notifier.refresh(),
                        tooltip: 'Refresh applications',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Refresh Icon Below Header

            // Body content (List/Error/Loading)
            Expanded(child: _buildBody(state, notifier)),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Applications screen
        onTap: (index) {
          if (index == 0) {
            // Already on Applications screen
          } else if (index == 1) {
            context.go('/student'); // 🔁 Navigate to internships screen
          } else if (index == 2) {
            context.go('/student/profile'); // 🔁 Navigate to profile screen
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Internships'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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