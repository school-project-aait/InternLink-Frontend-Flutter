import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/internship_provider.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/form_buttons.dart';
import '../widgets/form_section.dart';
import '../widgets/header_component.dart';


class AddInternshipScreen extends ConsumerStatefulWidget {
  const AddInternshipScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddInternshipScreen> createState() => _AddInternshipScreenState();
}

class _AddInternshipScreenState extends ConsumerState<AddInternshipScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(internshipProvider.notifier).loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(internshipProvider);
    final notifier = ref.read(internshipProvider.notifier);

    // Handle success state
    if (state.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Internship created successfully!')),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HeaderComponent(
              onLogout: () {
                // Handle logout
              },
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (state.error != null)
                      Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    FormSection(
                      title: 'Job Title',
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Job Title',
                        ),
                        onChanged: notifier.updateTitle,
                        initialValue: state.title,
                      ),
                    ),
                    FormSection(
                      title: 'Company Name',
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter company name',
                        ),
                        onChanged: notifier.updateCompanyName,
                        initialValue: state.companyName,
                      ),
                    ),
                    FormSection(
                      title: 'Requirements / Description',
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Requirements or Description',
                        ),
                        maxLines: 5,
                        onChanged: notifier.updateDescription,
                        initialValue: state.description,
                      ),
                    ),
                    FormSection(
                      title: 'Deadline',
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter deadline (YYYY-MM-DD)',
                        ),
                        onChanged: notifier.updateDeadline,
                        initialValue: state.deadline,
                      ),
                    ),
                    FormSection(
                      title: 'Category',
                      child: CategoryDropdown(
                        categories: state.categories,
                        selectedCategoryId: state.selectedCategoryId,
                        onCategorySelected: notifier.updateCategory,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FormButtons(
                      onSave: () => notifier.submit(),
                      onCancel: () {
                        notifier.reset();
                        Navigator.of(context).pop();
                      },
                    ),
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}