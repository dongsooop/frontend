import 'package:dongsoop/domain/user/entities/user_entity.dart';

class UserModel {
  final String nickname;
  final String departmentType;
  final String accessToken;

  UserModel({
    required this.nickname,
    required this.departmentType,
    required this.accessToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nickname: json['nickname'] ?? '',
      departmentType: json['departmentType'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'departmentType': departmentType,
      'accessToken': accessToken,
    };
  }
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      nickname: nickname,
      departmentType: departmentType,
      accessToken: accessToken,
    );
  }
}
