import 'internship_response.dart';

class InternshipListResponse {
  final List<InternshipResponse> internships;

  InternshipListResponse({required this.internships});

  factory InternshipListResponse.fromJson(Map<String, dynamic> json) {
    final internships = (json['internships'] as List)
        .map((e) => InternshipResponse.fromJson(e))
        .toList();
    return InternshipListResponse(internships: internships);
  }
}