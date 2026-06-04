// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialState _$SocialStateFromJson(Map<String, dynamic> json) => SocialState(
      providerType: json['providerType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SocialStateToJson(SocialState instance) =>
    <String, dynamic>{
      'providerType': instance.providerType,
      'createdAt': instance.createdAt.toIso8601String(),
    };
