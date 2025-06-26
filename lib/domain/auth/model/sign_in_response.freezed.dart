// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInResponse {
  int get id;
  String get accessToken;
  String get refreshToken;
  String get nickname;
  String get email;
  String get departmentType;

  /// Create a copy of SignInResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignInResponseCopyWith<SignInResponse> get copyWith =>
      _$SignInResponseCopyWithImpl<SignInResponse>(
          this as SignInResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignInResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.departmentType, departmentType) ||
                other.departmentType == departmentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, accessToken, refreshToken,
      nickname, email, departmentType);

  @override
  String toString() {
    return 'SignInResponse(id: $id, accessToken: $accessToken, refreshToken: $refreshToken, nickname: $nickname, email: $email, departmentType: $departmentType)';
  }
}

/// @nodoc
abstract mixin class $SignInResponseCopyWith<$Res> {
  factory $SignInResponseCopyWith(
          SignInResponse value, $Res Function(SignInResponse) _then) =
      _$SignInResponseCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String accessToken,
      String refreshToken,
      String nickname,
      String email,
      String departmentType});
}

/// @nodoc
class _$SignInResponseCopyWithImpl<$Res>
    implements $SignInResponseCopyWith<$Res> {
  _$SignInResponseCopyWithImpl(this._self, this._then);

  final SignInResponse _self;
  final $Res Function(SignInResponse) _then;

  /// Create a copy of SignInResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? nickname = null,
    Object? email = null,
    Object? departmentType = null,
  }) {
    return _then(SignInResponse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      accessToken: null == accessToken
          ? _self.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      departmentType: null == departmentType
          ? _self.departmentType
          : departmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
