import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers.dart';
import '../../domain/entities/internship.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/form_buttons.dart';
import '../widgets/form_section.dart';
import '../widgets/header_component.dart';

class AddEditInternshipScreen extends ConsumerStatefulWidget {
  final Internship? internship;

  const AddEditInternshipScreen({Key? key, this.internship}) : super(key: key);

  @override
  ConsumerState<AddEditInternshipScreen> createState() => _AddEditInternshipScreenState();
}

class _AddEditInternshipScreenState extends ConsumerState<AddEditInternshipScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(internshipProvider.notifier).initialize(
        existingInternship: widget.internship,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(internshipProvider);
    final notifier = ref.read(internshipProvider.notifier);

    if (state.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.isEditing
                ? 'Internship updated successfully!'
                : 'Internship created successfully!'),
          ),
        );
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing ? 'Edit Internship' : 'Add Internship'),
      ),
      body: state.isLoading && state.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
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
                isLoading: state.isLoading,
              ),
            ),
            const SizedBox(height: 16),
            FormButtons(
              onSave: () => notifier.submit(),
              onCancel: () {
                notifier.reset();
                Navigator.of(context).pop();
              },
              isEditing: state.isEditing,
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}