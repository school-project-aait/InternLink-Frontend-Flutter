import 'package:internlink_flutter_application/features/admin/domain/entities/category.dart';
import 'package:internlink_flutter_application/features/admin/domain/entities/internship.dart';

class InternshipState {
  final String title;
  final String description;
  final String deadline;
  final String companyName;
  final int? selectedCategoryId;
  final List<Category> categories;
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final Internship? internshipToEdit;

  InternshipState({
    this.title = '',
    this.description = '',
    this.deadline = '',
    this.companyName = '',
    this.selectedCategoryId,
    this.categories = const [],
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.internshipToEdit,
  });

  bool get isEditing => internshipToEdit != null;

  InternshipState copyWith({
    String? title,
    String? description,
    String? deadline,
    String? companyName,
    int? selectedCategoryId,
    List<Category>? categories,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    Internship? internshipToEdit,
  }) {
    return InternshipState(
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      companyName: companyName ?? this.companyName,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      internshipToEdit: internshipToEdit ?? this.internshipToEdit,
    );
  }
}