import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/features/admin/presenation/widgets/header_component.dart';

import '../../../../providers.dart';
import '../../domain/entities/internship.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/form_buttons.dart';
import '../widgets/form_section.dart';

class AddEditInternshipScreen extends ConsumerStatefulWidget {
  final Internship? internship;

  const AddEditInternshipScreen({Key? key, this.internship}) : super(key: key);

  @override
  ConsumerState<AddEditInternshipScreen> createState() => _AddEditInternshipScreenState();
}

class _AddEditInternshipScreenState extends ConsumerState<AddEditInternshipScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(internshipProvider.notifier).initialize(
        existingInternship: widget.internship,
      );
    });
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final success = await ref.read(internshipProvider.notifier).submit();

    if (mounted) {
      setState(() => _isSubmitting = false);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(internshipProvider).isEditing
                ? 'Internship updated successfully!'
                : 'Internship created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Wait briefly before popping the screen
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ This is the missing part
        Navigator.of(context).pop();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(internshipProvider);
    final notifier = ref.read(internshipProvider.notifier);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(state.isEditing ? 'Edit Internship' : 'Add Internship'),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  children: [
                    const BackButton(),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),  // adjust the left padding as needed
                      child: Text(
                        state.isEditing ? 'Edit Internship' : 'Add Internship',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),


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
                  onSave: _handleSubmit,
                  onCancel: () {
                    notifier.reset();
                    Navigator.of(context).pop();
                  },
                  isEditing: state.isEditing,
                  isLoading: _isSubmitting || state.isLoading,
                ),
              ],
            ),
          ),
          if (_isSubmitting || (state.isLoading && state.categories.isEmpty))
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}