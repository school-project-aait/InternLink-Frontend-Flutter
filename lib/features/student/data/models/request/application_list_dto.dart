// application_list_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'application_list_dto.g.dart';

@JsonSerializable()
class ApplicationListDto {
  @JsonKey(name: 'application_id')
  final int application_id;
  @JsonKey(name: 'user_id')
  final int user_id;
  @JsonKey(name: 'internship_id')
  final int internship_id;
  final String university;
  final String degree;
  @JsonKey(name: 'graduation_year')
  final int graduationYear;
  @JsonKey(name: 'linkdIn')
  final String linkedIn;
  @JsonKey(name: 'resume_id')
  final int resume_id;
  final String status;
  @JsonKey(name: 'internship_title')
  final String? internship_title;
  @JsonKey(name: 'company_name')
  final String? company_name;

  ApplicationListDto({
    required this.application_id,
    required this.user_id,
    required this.internship_id,
    required this.university,
    required this.degree,
    required this.graduationYear,
    required this.linkedIn,
    required this.resume_id,
    required this.status,
    this.internship_title,
    this.company_name,
  });

  factory ApplicationListDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationListDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationListDtoToJson(this);
}