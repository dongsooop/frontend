import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_request.freezed.dart';
part 'sign_up_request.g.dart';

@freezed
@JsonSerializable()
class SignUpRequest with _$SignUpRequest {
  final String email;
  final String password;
  final String nickname;
  final String departmentType;

  const SignUpRequest({
    required this.email,
    required this.password,
    required this.nickname,
    required this.departmentType,
  });

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}