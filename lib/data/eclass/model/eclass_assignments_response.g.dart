// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eclass_assignments_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EclassAssignmentsResponse _$EclassAssignmentsResponseFromJson(
        Map<String, dynamic> json) =>
    EclassAssignmentsResponse(
      linked: json['linked'] as bool,
      status: json['status'] as String?,
      assignments: (json['assignments'] as List<dynamic>)
          .map((e) =>
              EclassAssignmentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
