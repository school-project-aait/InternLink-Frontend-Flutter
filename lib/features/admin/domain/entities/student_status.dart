// lib/domain/entities/student_status.dart

class StudentStatus {
  final int id;
  final String name;
  final String email;
  final String resumeUrl;
  final String status;

  StudentStatus({
    required this.id,
    required this.name,
    required this.email,
    required this.resumeUrl,
    required this.status,
  });

  StudentStatus copyWith({String? status}) {
    return StudentStatus(
      id: id,
      name: name,
      email: email,
      resumeUrl: resumeUrl,
      status: status ?? this.status,
    );
  }
}
