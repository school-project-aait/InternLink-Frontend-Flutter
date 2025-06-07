import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/internship.dart';
// import 'package:internlink_flutter_application/features/internship/presentation/widgets/student_internship_card.dart';
import 'package:internlink_flutter_application/providers.dart';

import '../../../admin/presenation/state/internship_list_state.dart';
import '../widgets/student_internship_card.dart';

class StudentInternshipListScreen extends ConsumerStatefulWidget {
  const StudentInternshipListScreen({super.key});

  @override
  ConsumerState<StudentInternshipListScreen> createState() =>
      _StudentInternshipListScreenState();
}

class _StudentInternshipListScreenState
    extends ConsumerState<StudentInternshipListScreen> {
  @override
  void initState() {
    super.initState();
    // Load internships when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(internshipListProvider.notifier).loadInternships();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(internshipListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Internships'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(internshipListProvider.notifier).loadInternships(),
          ),
        ],
      ),
      body: _buildBody(state, theme),
      bottomNavigationBar:  BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Internships'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody(InternshipListState state, ThemeData theme) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.errorMessage!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(internshipListProvider.notifier).loadInternships(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.internships.isEmpty) {
      return Center(
        child: Text(
          'No internships available',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(internshipListProvider.notifier).loadInternships();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.internships.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final internship = state.internships[index];
          return StudentInternshipCard(
            internship: internship,
            onApply: () => _handleApply(internship),
          );
        },
      ),
    );
  }

  void _handleApply(Internship internship) {
    if (internship.status.toLowerCase() != 'active') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This internship is ${internship.status}. Applications are closed.',
          ),
        ),
      );
      return;
    }

    // Navigate to application screen
    Navigator.pushNamed(
      context,
      '/internship/${internship.id}/apply',
    );
  }
}