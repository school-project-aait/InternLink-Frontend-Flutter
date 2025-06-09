import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../domain/entities/internship.dart';
import '../providers/internship_list_notifier_provider.dart';
import '../state/internship_list_state.dart';
import '../widgets/header_component.dart';
import '../widgets/internship_card.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Load internships when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(internshipListProvider.notifier).loadInternships();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(internshipListProvider);
    final notifier = ref.read(internshipListProvider.notifier);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Handle error messages
    if (state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
        notifier.clearErrorMessage();
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
              child:
              HeaderComponent()
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // space between title and button
                    children: [
                      // Admin Dashboard Title
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 17),
                      // Review Applications button aligned right
                      TextButton(
                        onPressed: () {
                          context.push('/admin/applications/status', extra: {
                            'onLogout': () {
                              context.go('/login'); // or any logout logic
                            },
                            'onBackToDashboard': () {
                              context.go('/admin');
                            },
                          });
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(color: Colors.blueAccent, width: 2),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: const Text(
                          'Review Applications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
            Expanded(child: _buildBody(state, notifier, context)),
          ],
        ),
      ),
      // body: _buildBody(state, notifier, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push<bool>('/admin/internships/add');
          if (result == true) {
            ref.read(internshipListProvider.notifier).loadInternships();
          }
        },
        child: const Icon(Icons.add),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.push('/admin/internships/add'),
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildBody(
      InternshipListState state,
      InternshipListNotifier notifier,
      BuildContext context,
      ) {
    if (state.isLoading && state.internships.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.internships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.loadInternships(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.internships.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No internships available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.push('/admin/internships/add'),
              child: const Text('Create First Internship'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadInternships(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.internships.length,
        itemBuilder: (context, index) {
          final internship = state.internships[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InternshipCard(
              internship: internship,
              onTap: () => _showInternshipDetails(context, internship),
              onEdit: () => _navigateToEdit(context, internship),
              onDelete: () => notifier.deleteInternship(internship.id),
              isDeleting: state.isDeleting && state.deletingId == internship.id,
            ),

          );
          child: InternshipCard(
            internship: internship,
            onTap: () => _showInternshipDetails(context, internship),
            onEdit: () => _navigateToEdit(context, internship),
            onDelete: () => notifier.deleteInternship(internship.id),
            isDeleting: state.isDeleting && state.deletingId == internship.id,
          );
        },
      ),
    );
  }

  void _showInternshipDetails(BuildContext context, Internship internship) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(internship.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: ${internship.companyName}'),
              Text('Category: ${internship.categoryName}'),
              Text('Deadline: ${internship.deadline}'),
              if (internship.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                const Text('Description:'),
                Text(internship.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  void _navigateToEdit(BuildContext context, Internship internship) async {
    final result = await context.push<bool>(
      '/admin/internships/edit/${internship.id}',
      extra: internship,
    );

    if (result == true) {
      ref.read(internshipListProvider.notifier).loadInternships();
    }
  }

// void _navigateToEdit(BuildContext context, Internship internship) {
  //   context.push(
  //     '/admin/internships/edit/${internship.id}',
  //     extra: internship,
  //   );
  // }
}