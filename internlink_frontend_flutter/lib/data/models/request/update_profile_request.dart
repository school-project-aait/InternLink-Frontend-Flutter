class UpdateProfileRequest {
  final String name, email;
  final String? phone, address, gender;

  UpdateProfileRequest({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'gender': gender,
  };
}
