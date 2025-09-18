// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_join_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindJoinInfo {
  String get sessionId;
  String get name;

  /// Create a copy of BlindJoinInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindJoinInfoCopyWith<BlindJoinInfo> get copyWith =>
      _$BlindJoinInfoCopyWithImpl<BlindJoinInfo>(
          this as BlindJoinInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindJoinInfo &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, name);

  @override
  String toString() {
    return 'BlindJoinInfo(sessionId: $sessionId, name: $name)';
  }
}

/// @nodoc
abstract mixin class $BlindJoinInfoCopyWith<$Res> {
  factory $BlindJoinInfoCopyWith(
          BlindJoinInfo value, $Res Function(BlindJoinInfo) _then) =
      _$BlindJoinInfoCopyWithImpl;
  @useResult
  $Res call({String sessionId, String name});
}

/// @nodoc
class _$BlindJoinInfoCopyWithImpl<$Res>
    implements $BlindJoinInfoCopyWith<$Res> {
  _$BlindJoinInfoCopyWithImpl(this._self, this._then);

  final BlindJoinInfo _self;
  final $Res Function(BlindJoinInfo) _then;

  /// Create a copy of BlindJoinInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? name = null,
  }) {
    return _then(BlindJoinInfo(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
