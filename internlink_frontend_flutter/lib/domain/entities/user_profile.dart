class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phone, address, birthDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
  });
}
