import 'package:json_annotation/json_annotation.dart';

part 'application_request_dto.g.dart';

@JsonSerializable()
class ApplicationRequestDto {
  final int internship_id; // Match backend snake_case
  final String university;
  final String degree;
  @JsonKey(name: 'graduation_year') // Explicitly match backend field
  final int graduationYear;
  @JsonKey(name: 'linkdIn') // Match backend spelling exactly
  final String linkedIn;

  ApplicationRequestDto({
    required this.internship_id,
    required this.university,
    required this.degree,
    required this.graduationYear,
    required this.linkedIn,
  });

  factory ApplicationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationRequestDtoToJson(this);
}