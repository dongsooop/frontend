// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_ws.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomWs {
  String get roomId;
  String? get lastMessage;
  int get unreadCount;
  DateTime get timestamp;

  /// Create a copy of ChatRoomWs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomWsCopyWith<ChatRoomWs> get copyWith =>
      _$ChatRoomWsCopyWithImpl<ChatRoomWs>(this as ChatRoomWs, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoomWs &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, roomId, lastMessage, unreadCount, timestamp);

  @override
  String toString() {
    return 'ChatRoomWs(roomId: $roomId, lastMessage: $lastMessage, unreadCount: $unreadCount, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomWsCopyWith<$Res> {
  factory $ChatRoomWsCopyWith(
          ChatRoomWs value, $Res Function(ChatRoomWs) _then) =
      _$ChatRoomWsCopyWithImpl;
  @useResult
  $Res call(
      {String roomId,
      String? lastMessage,
      int unreadCount,
      DateTime timestamp});
}

/// @nodoc
class _$ChatRoomWsCopyWithImpl<$Res> implements $ChatRoomWsCopyWith<$Res> {
  _$ChatRoomWsCopyWithImpl(this._self, this._then);

  final ChatRoomWs _self;
  final $Res Function(ChatRoomWs) _then;

  /// Create a copy of ChatRoomWs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? timestamp = null,
  }) {
    return _then(ChatRoomWs(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _self.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
