// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUser {
  int get blockedMemberId;
  String get memberName;

  /// Create a copy of BlockedUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockedUserCopyWith<BlockedUser> get copyWith =>
      _$BlockedUserCopyWithImpl<BlockedUser>(this as BlockedUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockedUser &&
            (identical(other.blockedMemberId, blockedMemberId) ||
                other.blockedMemberId == blockedMemberId) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, blockedMemberId, memberName);

  @override
  String toString() {
    return 'BlockedUser(blockedMemberId: $blockedMemberId, memberName: $memberName)';
  }
}

/// @nodoc
abstract mixin class $BlockedUserCopyWith<$Res> {
  factory $BlockedUserCopyWith(
          BlockedUser value, $Res Function(BlockedUser) _then) =
      _$BlockedUserCopyWithImpl;
  @useResult
  $Res call({int blockedMemberId, String memberName});
}

/// @nodoc
class _$BlockedUserCopyWithImpl<$Res> implements $BlockedUserCopyWith<$Res> {
  _$BlockedUserCopyWithImpl(this._self, this._then);

  final BlockedUser _self;
  final $Res Function(BlockedUser) _then;

  /// Create a copy of BlockedUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedMemberId = null,
    Object? memberName = null,
  }) {
    return _then(BlockedUser(
      blockedMemberId: null == blockedMemberId
          ? _self.blockedMemberId
          : blockedMemberId // ignore: cast_nullable_to_non_nullable
              as int,
      memberName: null == memberName
          ? _self.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
