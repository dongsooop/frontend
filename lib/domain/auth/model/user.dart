import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@JsonSerializable()
class User with _$User {
  final int id;
  final String nickname;
  final String departmentType;
  final List<String> role;

  const User({
    required this.id,
    required this.nickname,
    required this.departmentType,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
