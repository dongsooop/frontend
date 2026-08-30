// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscribe_department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscribeDepartmentModel _$SubscribeDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    SubscribeDepartmentModel(
      departmentTypes: (json['departmentTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SubscribeDepartmentModelToJson(
        SubscribeDepartmentModel instance) =>
    <String, dynamic>{
      'departmentTypes': instance.departmentTypes,
    };
