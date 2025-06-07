import 'package:flutter/material.dart';

import '../../data/entities/category.dart';


class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;
  final Function(int) onCategorySelected;

  const CategoryDropdown({
    required this.categories,
    this.selectedCategoryId,
    required this.onCategorySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedCategoryId,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onCategorySelected(value);
        }
      },
      hint: const Text('Select a category'),
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}