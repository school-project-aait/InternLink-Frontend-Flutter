// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationUpdateDto _$ApplicationUpdateDtoFromJson(
        Map<String, dynamic> json) =>
    ApplicationUpdateDto(
      university: json['university'] as String,
      degree: json['degree'] as String,
      graduationYear: (json['graduation_year'] as num).toInt(),
      linkedIn: json['linkdIn'] as String,
    );

Map<String, dynamic> _$ApplicationUpdateDtoToJson(
        ApplicationUpdateDto instance) =>
    <String, dynamic>{
      'university': instance.university,
      'degree': instance.degree,
      'graduation_year': instance.graduationYear,
      'linkdIn': instance.linkedIn,
    };
