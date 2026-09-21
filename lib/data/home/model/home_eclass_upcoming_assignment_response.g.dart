// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_eclass_upcoming_assignment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeEclassUpcomingAssignmentResponse
    _$HomeEclassUpcomingAssignmentResponseFromJson(Map<String, dynamic> json) =>
        HomeEclassUpcomingAssignmentResponse(
          courseName: json['courseName'] as String,
          title: json['title'] as String,
          dueAt: DateTime.parse(json['dueAt'] as String),
          dDay: (json['dDay'] as num).toInt(),
          submitted: json['submitted'] as bool,
        );

Map<String, dynamic> _$HomeEclassUpcomingAssignmentResponseToJson(
        HomeEclassUpcomingAssignmentResponse instance) =>
    <String, dynamic>{
      'courseName': instance.courseName,
      'title': instance.title,
      'dueAt': instance.dueAt.toIso8601String(),
      'dDay': instance.dDay,
      'submitted': instance.submitted,
    };
