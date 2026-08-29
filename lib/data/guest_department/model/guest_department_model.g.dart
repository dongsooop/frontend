// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestDepartmentModel _$GuestDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    GuestDepartmentModel(
      departmentTypes: (json['departmentTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$GuestDepartmentModelToJson(
        GuestDepartmentModel instance) =>
    <String, dynamic>{
      'departmentTypes': instance.departmentTypes,
    };
