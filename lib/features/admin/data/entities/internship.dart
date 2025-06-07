class Internship {
  final int id;
  final String title;
  final String? description;
  final String deadline;
  final String companyName;
  final String categoryName;
  final String createdByName;
  final String createdAt;
  final String status;
  final bool isActive;

  Internship({
    required this.id,
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
}