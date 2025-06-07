import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internlink_flutter_application/core/utils/resource.dart';
import 'package:internlink_flutter_application/features/admin/domain/usecases/create_internship_usecase.dart';
import 'package:internlink_flutter_application/features/admin/domain/usecases/get_categories_usecase.dart';
import 'package:internlink_flutter_application/features/admin/domain/usecases/get_internship_by_id_usecase.dart';
import 'package:internlink_flutter_application/features/admin/domain/usecases/update_internship_usecase.dart';

import '../../../../providers.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/internship.dart';
import '../state/internship_state.dart';

class InternshipNotifier extends StateNotifier<InternshipState> {
  final CreateInternshipUseCase _createInternshipUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetInternshipByIdUseCase _getInternshipByIdUseCase;
  final UpdateInternshipUseCase _updateInternshipUseCase;

  InternshipNotifier({
    required CreateInternshipUseCase createInternshipUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetInternshipByIdUseCase getInternshipByIdUseCase,
    required UpdateInternshipUseCase updateInternshipUseCase,
  })  : _createInternshipUseCase = createInternshipUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _getInternshipByIdUseCase = getInternshipByIdUseCase,
        _updateInternshipUseCase = updateInternshipUseCase,
        super(InternshipState());

  Future<void> initialize({Internship? existingInternship}) async {
    state = state.copyWith(isLoading: true);

    final categoriesResult = await _getCategoriesUseCase();

    if (categoriesResult is ResourceSuccess<List<Category>>) {
      final categories = categoriesResult.data;
      if (existingInternship != null) {
        final category = categories.firstWhere(
              (c) => c.name == existingInternship.categoryName,
          orElse: () => Category(id: -1, name: existingInternship.categoryName),
        );

        state = state.copyWith(
          isLoading: false,
          categories: categories,
          title: existingInternship.title,
          description: existingInternship.description,
          deadline: existingInternship.deadline,
          companyName: existingInternship.companyName,
          selectedCategoryId: category.id,
          internshipToEdit: existingInternship,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          categories: categories,
        );
      }
    } else if (categoriesResult is ResourceError<List<Category>>) {
      state = state.copyWith(
        isLoading: false,
        error: categoriesResult.message,
      );
    }
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getCategoriesUseCase();

    if (result is ResourceSuccess<List<Category>>) {
      state = state.copyWith(
        isLoading: false,
        categories: result.data,
      );
    } else if (result is ResourceError<List<Category>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  Future<void> loadInternship(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getInternshipByIdUseCase(id);

    if (result is ResourceSuccess<Internship>) {
      final internship = result.data;
      final category = state.categories.firstWhere(
            (c) => c.name == internship.categoryName,
        orElse: () => Category(id: -1, name: internship.categoryName),
      );

      state = state.copyWith(
        isLoading: false,
        title: internship.title,
        description: internship.description,
        deadline: internship.deadline,
        companyName: internship.companyName,
        selectedCategoryId: category.id,
        internshipToEdit: internship,
      );
    } else if (result is ResourceError<Internship>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  void updateTitle(String title) => state = state.copyWith(title: title);
  void updateDescription(String description) => state = state.copyWith(description: description);
  void updateDeadline(String deadline) => state = state.copyWith(deadline: deadline);
  void updateCompanyName(String companyName) => state = state.copyWith(companyName: companyName);
  void updateCategory(int? categoryId) => state = state.copyWith(selectedCategoryId: categoryId);

  Future<bool> submit() async {
    if (state.title.isEmpty ||
        state.companyName.isEmpty ||
        state.selectedCategoryId == null ||
        state.deadline.isEmpty) {
      state = state.copyWith(error: 'All fields are required');
      return false;
    }

    final selectedCategory = state.categories.firstWhere(
          (c) => c.id == state.selectedCategoryId,
    );

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    final result = state.isEditing
        ? await _updateInternshipUseCase(
      id: state.internshipToEdit!.id,
      title: state.title,
      description: state.description,
      deadline: state.deadline,
      companyName: state.companyName,
      categoryId: state.selectedCategoryId,
      categoryName: selectedCategory.name,
    )
        : await _createInternshipUseCase(
      title: state.title,
      description: state.description,
      deadline: state.deadline,
      companyName: state.companyName,
      categoryId: state.selectedCategoryId!,
      categoryName: selectedCategory.name,
    );

    bool success = false;
    if (result is ResourceSuccess<bool>) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
      success = true;
    } else if (result is ResourceError<bool>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }

    return success;
  }

  void reset() {
    state = InternshipState(categories: state.categories);
  }
}

final internshipProvider = StateNotifierProvider<InternshipNotifier, InternshipState>((ref) {
  return InternshipNotifier(
    createInternshipUseCase: ref.read(createInternshipUseCaseProvider),
    getCategoriesUseCase: ref.read(getCategoriesUseCaseProvider),
    getInternshipByIdUseCase: ref.read(getInternshipByIdUseCaseProvider),
    updateInternshipUseCase: ref.read(updateInternshipUseCaseProvider),
  );
});