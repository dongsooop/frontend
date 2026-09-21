// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eclass_assignment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EclassAssignmentResponse _$EclassAssignmentResponseFromJson(
        Map<String, dynamic> json) =>
    EclassAssignmentResponse(
      id: (json['id'] as num).toInt(),
      assignId: (json['assignId'] as num).toInt(),
      courseName: json['courseName'] as String,
      title: json['title'] as String,
      dueAt: DateTime.parse(json['dueAt'] as String),
      cutoffAt: json['cutoffAt'] == null
          ? null
          : DateTime.parse(json['cutoffAt'] as String),
      dDay: (json['dDay'] as num).toInt(),
      submitted: json['submitted'] as bool,
      link: json['link'] as String,
    );
