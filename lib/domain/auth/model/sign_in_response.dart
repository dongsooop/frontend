import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_response.freezed.dart';
part 'sign_in_response.g.dart';

@freezed
@JsonSerializable()
class SignInResponse with _$SignInResponse {
  final int id;
  final String accessToken;
  final String refreshToken;
  final String nickname;
  final String email;
  final String departmentType;
  final List<String> role;

  const SignInResponse({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.nickname,
    required this.email,
    required this.departmentType,
    required this.role,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) => _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}