class InternshipResponse {
  final int internshipId;
  final String title;
  final String? description;
  final String deadline;
  final int isActive;
  final String status;
  final String companyName;
  final String categoryName; // Remove categoryId since your backend doesn't provide it
  final String createdByName;
  final String createdAt;
  final String updatedAt;

  InternshipResponse({
    required this.internshipId,
    required this.title,
    this.description,
    required this.deadline,
    required this.isActive,
    required this.status,
    required this.companyName,
    required this.categoryName,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InternshipResponse.fromJson(Map<String, dynamic> json) {
    return InternshipResponse(
      internshipId: json['internship_id'],
      title: json['title'],
      description: json['description'],
      deadline: json['deadline'],
      isActive: json['is_active'],
      status: json['status'],
      companyName: json['company_name'],
      categoryName: json['category_name'],
      createdByName: json['created_by_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}