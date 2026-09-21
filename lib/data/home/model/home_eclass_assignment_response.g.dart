// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_eclass_assignment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeEclassAssignmentResponse _$HomeEclassAssignmentResponseFromJson(
        Map<String, dynamic> json) =>
    HomeEclassAssignmentResponse(
      linked: json['linked'] as bool,
      status: json['status'] as String?,
      upcomingCount: (json['upcomingCount'] as num).toInt(),
      upcoming: (json['upcoming'] as List<dynamic>?)
          ?.map((e) => HomeEclassUpcomingAssignmentResponse.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      nearestCourseName: json['nearestCourseName'] as String?,
      nearestTitle: json['nearestTitle'] as String?,
      nearestDueAt: json['nearestDueAt'] == null
          ? null
          : DateTime.parse(json['nearestDueAt'] as String),
      nearestDDay: (json['nearestDDay'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeEclassAssignmentResponseToJson(
        HomeEclassAssignmentResponse instance) =>
    <String, dynamic>{
      'linked': instance.linked,
      'status': instance.status,
      'upcomingCount': instance.upcomingCount,
      'upcoming': instance.upcoming,
      'nearestCourseName': instance.nearestCourseName,
      'nearestTitle': instance.nearestTitle,
      'nearestDueAt': instance.nearestDueAt?.toIso8601String(),
      'nearestDDay': instance.nearestDDay,
    };
