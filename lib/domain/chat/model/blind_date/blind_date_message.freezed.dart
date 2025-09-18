// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_date_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindDateMessage {
  String get message;
  int get memberId;
  String get name;
  DateTime get sendAt;
  String get type;
  set type(String value);

  /// Create a copy of BlindDateMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindDateMessageCopyWith<BlindDateMessage> get copyWith =>
      _$BlindDateMessageCopyWithImpl<BlindDateMessage>(
          this as BlindDateMessage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindDateMessage &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sendAt, sendAt) || other.sendAt == sendAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, message, memberId, name, sendAt, type);

  @override
  String toString() {
    return 'BlindDateMessage(message: $message, memberId: $memberId, name: $name, sendAt: $sendAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $BlindDateMessageCopyWith<$Res> {
  factory $BlindDateMessageCopyWith(
          BlindDateMessage value, $Res Function(BlindDateMessage) _then) =
      _$BlindDateMessageCopyWithImpl;
  @useResult
  $Res call(
      {String message,
      int memberId,
      String name,
      DateTime sendAt,
      String type});
}

/// @nodoc
class _$BlindDateMessageCopyWithImpl<$Res>
    implements $BlindDateMessageCopyWith<$Res> {
  _$BlindDateMessageCopyWithImpl(this._self, this._then);

  final BlindDateMessage _self;
  final $Res Function(BlindDateMessage) _then;

  /// Create a copy of BlindDateMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? memberId = null,
    Object? name = null,
    Object? sendAt = null,
    Object? type = null,
  }) {
    return _then(BlindDateMessage(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sendAt: null == sendAt
          ? _self.sendAt
          : sendAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
