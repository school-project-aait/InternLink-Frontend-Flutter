// application_update_dto.dart
import 'package:json_annotation/json_annotation.dart';

part 'application_update_dto.g.dart';

@JsonSerializable()
class ApplicationUpdateDto {
  final String university;
  final String degree;
  @JsonKey(name: 'graduation_year')
  final int graduationYear;
  @JsonKey(name: 'linkdIn')
  final String linkedIn;

  ApplicationUpdateDto({
    required this.university,
    required this.degree,
    required this.graduationYear,
    required this.linkedIn,
  });

  factory ApplicationUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$ApplicationUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationUpdateDtoToJson(this);}