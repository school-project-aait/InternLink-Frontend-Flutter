import 'package:internlink_frontend_flutter/domain/entities/user_profile.dart';

class ProfileDto {
  final int id;
  final String name;
  final String email;
  final String? phone, address, birthDate;

  ProfileDto({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.birthDate,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) => ProfileDto(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    birthDate: json['birthDate'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'birthDate': birthDate,
  };

  UserProfile toEntity() => UserProfile(
    id: id,
    name: name,
    email: email,
    phone: phone,
    address: address,
    birthDate: birthDate,
  );

  static ProfileDto fromEntity(UserProfile profile) => ProfileDto(
    id: profile.id,
    name: profile.name,
    email: profile.email,
    phone: profile.phone,
    address: profile.address,
    birthDate: profile.birthDate,
  );
}
