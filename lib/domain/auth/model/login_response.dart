import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
@JsonSerializable()
class LoginResponse with _$LoginResponse {
  final int id;
  final String accessToken;
  final String refreshToken;
  final String nickname;
  final String email;
  final String departmentType;

  const LoginResponse({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.nickname,
    required this.email,
    required this.departmentType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}