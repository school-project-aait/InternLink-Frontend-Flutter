class UpdateInternshipRequest {
  final String? title;
  final String? description;
  final String? deadline;
  final String? companyName;
  final int? categoryId;

  UpdateInternshipRequest({
    this.title,
    this.description,
    this.deadline,
    this.companyName,
    this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (deadline != null) 'deadline': deadline,
    if (companyName != null) 'company_name': companyName,
    if (categoryId != null) 'category_id': categoryId,
  };
}