import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.fullName,
    required super.gender,
    required super.email,
    required super.dob,
    required super.contactNumber,
    required super.address,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json['full_name'],
        gender: json['gender'],
        email: json['email'],
        dob: json['dob'],
        contactNumber: json['contact_number'],
        address: json['address'],
        password: '',
      );

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'gender': gender,
        'email': email,
        'dob': dob,
        'contact_number': contactNumber,
        'address': address,
        'password': password,
      };
}
