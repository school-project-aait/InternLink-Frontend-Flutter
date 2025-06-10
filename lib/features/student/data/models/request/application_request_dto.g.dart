// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationRequestDto _$ApplicationRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationRequestDto(
      internship_id: (json['internship_id'] as num).toInt(),
      university: json['university'] as String,
      degree: json['degree'] as String,
      graduationYear: (json['graduation_year'] as num).toInt(),
      linkedIn: json['linkdIn'] as String,
    );

Map<String, dynamic> _$ApplicationRequestDtoToJson(
        ApplicationRequestDto instance) =>
    <String, dynamic>{
      'internship_id': instance.internship_id,
      'university': instance.university,
      'degree': instance.degree,
      'graduation_year': instance.graduationYear,
      'linkdIn': instance.linkedIn,
    };
