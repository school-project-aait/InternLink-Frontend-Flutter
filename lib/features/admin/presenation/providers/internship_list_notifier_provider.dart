import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/resource.dart';
import '../../../../providers.dart';
import '../../domain/entities/internship.dart';
import '../../domain/usecases/delete_internship_usecase.dart';
import '../../domain/usecases/get_internships_usecase.dart';
import '../state/internship_list_state.dart';


class InternshipListNotifier extends StateNotifier<InternshipListState> {
  final GetInternshipsUseCase getInternshipsUseCase;
  final DeleteInternshipUseCase deleteInternshipUseCase;

  InternshipListNotifier({
    required this.getInternshipsUseCase,
    required this.deleteInternshipUseCase,
  }) : super(const InternshipListState());

  Future<void> loadInternships() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await getInternshipsUseCase();

    if (result is ResourceSuccess<List<Internship>>) {
      state = state.copyWith(
        isLoading: false,
        internships: result.data,
      );
    } else if (result is ResourceError<List<Internship>>) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.message,
      );
    }
  }

  Future<void> deleteInternship(int id) async {
    state = state.copyWith(isDeleting: true, deletingId: id);
    final result = await deleteInternshipUseCase(id);

    if (result is ResourceSuccess<bool> && result.data) {
      state = state.copyWith(
        isDeleting: false,
        deletingId: null,
        internships: state.internships.where((i) => i.id != id).toList(),
      );
    } else if (result is ResourceError<bool>) {
      state = state.copyWith(
        isDeleting: false,
        deletingId: null,
        errorMessage: result.message,
      );
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}

final internshipListProvider = StateNotifierProvider<InternshipListNotifier, InternshipListState>((ref) {
  return InternshipListNotifier(
    getInternshipsUseCase: ref.read(getInternshipsUseCaseProvider),
    deleteInternshipUseCase: ref.read(deleteInternshipUseCaseProvider),
  );
});