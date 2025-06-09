class UpdateProfileRequest {
  final String name, email;
  final String? phone, address, birthDate;

  UpdateProfileRequest({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'birthDate': birthDate,
  };
}
