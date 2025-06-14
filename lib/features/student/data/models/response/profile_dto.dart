import '../../../domain/entities/user_profile.dart';

class ProfileDto {
  final int id;
  final String name;
  final String email;
  final String? phone, address, gender;

  ProfileDto({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.gender,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
    id: json['id'] as int? ?? 0, // Provide default if null
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    gender: json['gender'] as String?,
  );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'gender': gender,
      };

  UserProfile toEntity() => UserProfile(
        id: id,
        name: name,
        email: email,
        phone: phone,
        address: address,
        gender: gender,
      );

  static ProfileDto fromEntity(UserProfile profile) => ProfileDto(
        id: profile.id,
        name: profile.name,
        email: profile.email,
        phone: profile.phone,
        address: profile.address,
        gender: profile.gender,
      );
}
