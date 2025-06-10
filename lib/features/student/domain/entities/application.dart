class Application {
  final int id;
  final int userId;
  final int internshipId;
  final String university;
  final String degree;
  final int graduationYear;
  final String linkedIn;
  final int resumeId;
  final String status;
  final String? internshipTitle;
  final String? companyName;

  Application({
    required this.id,
    required this.userId,
    required this.internshipId,
    required this.university,
    required this.degree,
    required this.graduationYear,
    required this.linkedIn,
    required this.resumeId,
    required this.status,
    this.internshipTitle,
    this.companyName,
  });
}