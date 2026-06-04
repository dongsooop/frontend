// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureCountModel _$FeatureCountModelFromJson(Map<String, dynamic> json) =>
    FeatureCountModel(
      serviceFeatureName: json['serviceFeatureName'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$FeatureCountModelToJson(FeatureCountModel instance) =>
    <String, dynamic>{
      'serviceFeatureName': instance.serviceFeatureName,
      'count': instance.count,
    };
