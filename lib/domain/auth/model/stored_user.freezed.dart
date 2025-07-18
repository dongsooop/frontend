// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stored_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoredUser {
  int get id;
  String get nickname;
  String get departmentType;
  String get accessToken;
  String get refreshToken;
  String get role;

  /// Create a copy of StoredUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoredUserCopyWith<StoredUser> get copyWith =>
      _$StoredUserCopyWithImpl<StoredUser>(this as StoredUser, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoredUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.departmentType, departmentType) ||
                other.departmentType == departmentType) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.role, role) || other.role == role));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, departmentType,
      accessToken, refreshToken, role);

  @override
  String toString() {
    return 'StoredUser(id: $id, nickname: $nickname, departmentType: $departmentType, accessToken: $accessToken, refreshToken: $refreshToken, role: $role)';
  }
}

/// @nodoc
abstract mixin class $StoredUserCopyWith<$Res> {
  factory $StoredUserCopyWith(
          StoredUser value, $Res Function(StoredUser) _then) =
      _$StoredUserCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String nickname,
      String departmentType,
      String accessToken,
      String refreshToken,
      String role});
}

/// @nodoc
class _$StoredUserCopyWithImpl<$Res> implements $StoredUserCopyWith<$Res> {
  _$StoredUserCopyWithImpl(this._self, this._then);

  final StoredUser _self;
  final $Res Function(StoredUser) _then;

  /// Create a copy of StoredUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? departmentType = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? role = null,
  }) {
    return _then(StoredUser(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      departmentType: null == departmentType
          ? _self.departmentType
          : departmentType // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
