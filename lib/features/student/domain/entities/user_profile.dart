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
  }) {
    if (id == null) throw ArgumentError("Profile ID cannot be null");
    if (name.isEmpty) throw ArgumentError("Name cannot be empty");
    if (email.isEmpty) throw ArgumentError("Email cannot be empty");
  }
}
