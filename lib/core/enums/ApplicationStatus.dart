enum ApplicationStatus {
  pending,
  accepted,
  rejected;

  factory ApplicationStatus.fromString(String status) {
    return ApplicationStatus.values.firstWhere(
          (e) => e.name == status.toLowerCase(),
      orElse: () => ApplicationStatus.pending,
    );
  }
}