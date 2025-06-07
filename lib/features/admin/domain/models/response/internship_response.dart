class InternshipResponse {
  final int internshipId;
  final String title;
  final String? description;
  final String deadline;
  final String companyName;
  final String categoryName;
  final String createdByName;
  final String createdAt;
  final String status;
  final bool isActive;

  InternshipResponse({
    required this.internshipId,
    required this.title,
    this.description,
    required this.deadline,
    required this.companyName,
    required this.categoryName,
    required this.createdByName,
    required this.createdAt,
    required this.status,
    required this.isActive,
  });

  factory InternshipResponse.fromJson(Map<String, dynamic> json) {
    return InternshipResponse(
      internshipId: json['internship_id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      companyName: json['company_name'],
      categoryName: json['category_name'],
      createdByName: json['created_by_name'],
      createdAt: json['created_at'],
      status: json['status'],
      isActive: json['is_active'],
    );
  }
}