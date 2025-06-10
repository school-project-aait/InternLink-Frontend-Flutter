class UpdateProfileRequest {
  final String name;
  final String? phone, address, gender;

  UpdateProfileRequest({
    required this.name,
    this.phone,
    this.address,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'address': address,
    'gender': gender,
  };
}