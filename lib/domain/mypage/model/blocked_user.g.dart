// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUser _$BlockedUserFromJson(Map<String, dynamic> json) => BlockedUser(
      blockedMemberId: (json['blockedMemberId'] as num).toInt(),
      memberName: json['memberName'] as String,
    );

Map<String, dynamic> _$BlockedUserToJson(BlockedUser instance) =>
    <String, dynamic>{
      'blockedMemberId': instance.blockedMemberId,
      'memberName': instance.memberName,
    };
