

import '../../domain/entities/internship.dart';

class InternshipListState {
  final List<Internship> internships;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleting;
  final int? deletingId;

  const InternshipListState({
    this.internships = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isDeleting = false,
    this.deletingId,
  });

  InternshipListState copyWith({
    List<Internship>? internships,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleting,
    int? deletingId,
  }) {
    return InternshipListState(
      internships: internships ?? this.internships,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeleting: isDeleting ?? this.isDeleting,
      deletingId: deletingId ?? this.deletingId,
    );
  }
}