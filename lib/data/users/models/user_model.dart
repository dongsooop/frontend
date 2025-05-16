import 'package:dongsoop/domain/users/entities/user_entity.dart';

class UserModel {
  final int id;
  final String email;
  final String password;
  final String nickname;
  final String departmentType;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.nickname,
    required this.departmentType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('json: $json');
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      departmentType: json['departmentType'] as String? ?? '',
    );
  }
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        id: id,
        email: email,
        password: password,
        nickname: nickname,
        departmentType: departmentType);
  }
}
