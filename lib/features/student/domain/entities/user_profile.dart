class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phone, address, gender;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.gender,
  });
}
