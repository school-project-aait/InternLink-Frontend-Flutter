import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../providers.dart';
import '../../data/entities/category.dart';
import '../../data/usecases/create_internship_usecase.dart';
import '../../data/usecases/get_categories_usecase.dart';

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
  });

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
    );
  }
}

class InternshipNotifier extends StateNotifier<InternshipState> {
  final CreateInternshipUseCase createInternshipUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  InternshipNotifier({
    required this.createInternshipUseCase,
    required this.getCategoriesUseCase,
  }) : super(InternshipState()) {
    loadCategories();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await getCategoriesUseCase();

    result.when(
      success: (categories) {
        state = state.copyWith(
          isLoading: false,
          categories: categories,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          error: message,
        );
      },
      loading: () {
        state = state.copyWith(isLoading: true);
      },
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateDeadline(String deadline) {
    state = state.copyWith(deadline: deadline);
  }

  void updateCompanyName(String companyName) {
    state = state.copyWith(companyName: companyName);
  }

  void updateCategory(int categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  Future<void> submit() async {
    if (state.title.isEmpty ||
        state.companyName.isEmpty ||
        state.selectedCategoryId == null ||
        state.deadline.isEmpty) {
      state = state.copyWith(error: 'All fields are required');
      return;
    }

    state = state.copyWith(isLoading: true, error: null, isSuccess: false);
    final result = await createInternshipUseCase(
      title: state.title,
      description: state.description,
      deadline: state.deadline,
      companyName: state.companyName,
      categoryId: state.selectedCategoryId!,
    );

    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          title: '',
          description: '',
          deadline: '',
          companyName: '',
          selectedCategoryId: null,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isLoading: false,
          error: message,
        );
      },
      loading: () {
        state = state.copyWith(isLoading: true);
      },
    );
  }

  void reset() {
    state = InternshipState(categories: state.categories);
  }
}

final internshipProvider = StateNotifierProvider<InternshipNotifier, InternshipState>((ref) {
  return InternshipNotifier(
    createInternshipUseCase: ref.read(createInternshipUseCaseProvider),
    getCategoriesUseCase: ref.read(getCategoriesUseCaseProvider),
  );
});