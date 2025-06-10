// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationDto _$ApplicationDtoFromJson(Map<String, dynamic> json) =>
    ApplicationDto(
      application_id: (json['application_id'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      internship_id: (json['internship_id'] as num).toInt(),
      university: json['university'] as String,
      degree: json['degree'] as String,
      graduationYear: (json['graduation_year'] as num).toInt(),
      linkedIn: json['linkdIn'] as String,
      resume_id: (json['resume_id'] as num).toInt(),
      status: json['status'] as String,
      internship_title: json['internship_title'] as String?,
      company_name: json['company_name'] as String?,
    );

Map<String, dynamic> _$ApplicationDtoToJson(ApplicationDto instance) =>
    <String, dynamic>{
      'application_id': instance.application_id,
      'user_id': instance.user_id,
      'internship_id': instance.internship_id,
      'university': instance.university,
      'degree': instance.degree,
      'graduation_year': instance.graduationYear,
      'linkdIn': instance.linkedIn,
      'resume_id': instance.resume_id,
      'status': instance.status,
      'internship_title': instance.internship_title,
      'company_name': instance.company_name,
    };
