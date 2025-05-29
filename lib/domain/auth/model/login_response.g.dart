// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: (json['id'] as num).toInt(),
      accessToken: json['accessToken'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      departmentType: json['departmentType'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accessToken': instance.accessToken,
      'nickname': instance.nickname,
      'email': instance.email,
      'departmentType': instance.departmentType,
    };
