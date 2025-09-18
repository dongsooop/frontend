// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_date_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindDateRequest {
  String get sessionId;
  String get message;
  int get senderId;

  /// Create a copy of BlindDateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindDateRequestCopyWith<BlindDateRequest> get copyWith =>
      _$BlindDateRequestCopyWithImpl<BlindDateRequest>(
          this as BlindDateRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindDateRequest &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, message, senderId);

  @override
  String toString() {
    return 'BlindDateRequest(sessionId: $sessionId, message: $message, senderId: $senderId)';
  }
}

/// @nodoc
abstract mixin class $BlindDateRequestCopyWith<$Res> {
  factory $BlindDateRequestCopyWith(
          BlindDateRequest value, $Res Function(BlindDateRequest) _then) =
      _$BlindDateRequestCopyWithImpl;
  @useResult
  $Res call({String sessionId, String message, int senderId});
}

/// @nodoc
class _$BlindDateRequestCopyWithImpl<$Res>
    implements $BlindDateRequestCopyWith<$Res> {
  _$BlindDateRequestCopyWithImpl(this._self, this._then);

  final BlindDateRequest _self;
  final $Res Function(BlindDateRequest) _then;

  /// Create a copy of BlindDateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? message = null,
    Object? senderId = null,
  }) {
    return _then(BlindDateRequest(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
