class UserEntity {
  final int id;
  final String email;
  final String password;
  final String nickname;
  final String departmentType;

  // 생성자
  UserEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.nickname,
    required this.departmentType,
  });
}
