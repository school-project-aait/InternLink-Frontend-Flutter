class CreateInternshipRequest {
  final String title;
  final String? description;
  final String deadline;
  final String companyName;
  final int categoryId;

  CreateInternshipRequest({
    required this.title,
    this.description,
    required this.deadline,
    required this.companyName,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'deadline': deadline,
    'company_name': companyName,
    'category_id': categoryId,
  };
}