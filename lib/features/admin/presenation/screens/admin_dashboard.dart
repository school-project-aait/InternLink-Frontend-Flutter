import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../domain/entities/internship.dart';
import '../providers/internship_list_provider.dart';
import '../state/internship_list_state.dart';
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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.loadInternships(),
          ),
        ],
      ),
      body: _buildBody(state, notifier, context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/internships/add'),
        child: const Icon(Icons.add),
      ),
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
          return InternshipCard(
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

  void _navigateToEdit(BuildContext context, Internship internship) {
    context.push(
      '/admin/internships/edit/${internship.id}',
      extra: internship,
    );
  }
}