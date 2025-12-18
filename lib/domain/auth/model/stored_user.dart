import 'package:freezed_annotation/freezed_annotation.dart';

part 'stored_user.freezed.dart';

@freezed
class StoredUser with _$StoredUser {
  final int id;
  final String nickname;
  final String departmentType;
  final String accessToken;
  final String refreshToken;
  final List<String> role;

  const StoredUser({
    required this.id,
    required this.nickname,
    required this.departmentType,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });
}
