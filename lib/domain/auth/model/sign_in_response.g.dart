// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponse _$SignInResponseFromJson(Map<String, dynamic> json) =>
    SignInResponse(
      id: (json['id'] as num).toInt(),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      departmentType: json['departmentType'] as String,
      role: (json['role'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SignInResponseToJson(SignInResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'nickname': instance.nickname,
      'email': instance.email,
      'departmentType': instance.departmentType,
      'role': instance.role,
    };
