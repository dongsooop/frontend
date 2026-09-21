// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eclass_link_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EclassLinkResponse _$EclassLinkResponseFromJson(Map<String, dynamic> json) =>
    EclassLinkResponse(
      linked: json['linked'] as bool,
      status: json['status'] as String?,
      moodleFullname: json['moodleFullname'] as String?,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
    );
