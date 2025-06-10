import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/internship.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/header_component.dart';
import 'package:internlink_flutter_application/providers.dart';
import '../../../admin/presenation/state/internship_list_state.dart';
import '../widgets/student_internship_card.dart';

class StudentInternshipListScreen extends ConsumerStatefulWidget {
  const StudentInternshipListScreen({super.key});

  @override
  ConsumerState<StudentInternshipListScreen> createState() =>
      _StudentInternshipListScreenState(); // Fixed the state class name
}

class _StudentInternshipListScreenState // Corrected state class name
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 0),
              child:
              HeaderComponent()
          ), // ✅ Your custom header widget
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  'Available Internships',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref
                      .read(internshipListProvider.notifier)
                      .loadInternships(),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(state, theme)), // Internships list
        ],
      ),
      // body: _buildBody(state, theme),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            context.go('/student/applications'); // ✅ Navigate to applications screen
          } else if (index == 1) {
            // Already on internship list, do nothing
          } else if (index == 2) {
            context.go('/student/profile'); // ✅ Navigate to profile
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
              onPressed: () =>
                  ref.read(internshipListProvider.notifier).loadInternships(),
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
    // Directly navigate to application screen without any checks
    // context.push('/api/applications/${internship.id}');
    context.push('/student/applications/${internship.id}');
  }
}
