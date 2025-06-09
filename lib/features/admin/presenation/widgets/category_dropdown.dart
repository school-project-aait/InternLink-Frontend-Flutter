import 'package:flutter/material.dart';


import '../../domain/entities/category.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int?) onCategorySelected;
  final bool isLoading;

  const CategoryDropdown({
    Key? key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const LinearProgressIndicator();
    // }

    return DropdownButtonFormField<int>(
      value: selectedCategoryId,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: onCategorySelected,
      hint: const Text('Select Category'),
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}