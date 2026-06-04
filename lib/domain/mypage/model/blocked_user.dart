import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocked_user.freezed.dart';
part 'blocked_user.g.dart';

@freezed
@JsonSerializable()
class BlockedUser with _$BlockedUser {
  final int blockedMemberId;
  final String memberName;

  const BlockedUser({
    required this.blockedMemberId,
    required this.memberName,
  });

  Map<String, dynamic> toJson() => _$BlockedUserToJson(this);
  factory BlockedUser.fromJson(Map<String, dynamic> json) => _$BlockedUserFromJson(json);
}