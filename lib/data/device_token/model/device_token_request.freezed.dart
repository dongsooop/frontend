// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_token_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceTokenRequest {
  String get deviceToken;
  String get type;

  /// Create a copy of DeviceTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceTokenRequestCopyWith<DeviceTokenRequest> get copyWith =>
      _$DeviceTokenRequestCopyWithImpl<DeviceTokenRequest>(
          this as DeviceTokenRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeviceTokenRequest &&
            (identical(other.deviceToken, deviceToken) ||
                other.deviceToken == deviceToken) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceToken, type);

  @override
  String toString() {
    return 'DeviceTokenRequest(deviceToken: $deviceToken, type: $type)';
  }
}

/// @nodoc
abstract mixin class $DeviceTokenRequestCopyWith<$Res> {
  factory $DeviceTokenRequestCopyWith(
          DeviceTokenRequest value, $Res Function(DeviceTokenRequest) _then) =
      _$DeviceTokenRequestCopyWithImpl;
  @useResult
  $Res call({String deviceToken, String type});
}

/// @nodoc
class _$DeviceTokenRequestCopyWithImpl<$Res>
    implements $DeviceTokenRequestCopyWith<$Res> {
  _$DeviceTokenRequestCopyWithImpl(this._self, this._then);

  final DeviceTokenRequest _self;
  final $Res Function(DeviceTokenRequest) _then;

  /// Create a copy of DeviceTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceToken = null,
    Object? type = null,
  }) {
    return _then(DeviceTokenRequest(
      deviceToken: null == deviceToken
          ? _self.deviceToken
          : deviceToken // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
