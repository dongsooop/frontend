// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoom {
  String get roomId;
  String? get title;
  List<int> get participants;
  int? get managerId;
  DateTime get createdAt;
  DateTime get lastActivityAt;
  List<int> get kickedUsers;
  bool get groupChat;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      _$ChatRoomCopyWithImpl<ChatRoom>(this as ChatRoom, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoom &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.participants, participants) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            const DeepCollectionEquality()
                .equals(other.kickedUsers, kickedUsers) &&
            (identical(other.groupChat, groupChat) ||
                other.groupChat == groupChat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      roomId,
      title,
      const DeepCollectionEquality().hash(participants),
      managerId,
      createdAt,
      lastActivityAt,
      const DeepCollectionEquality().hash(kickedUsers),
      groupChat);

  @override
  String toString() {
    return 'ChatRoom(roomId: $roomId, title: $title, participants: $participants, managerId: $managerId, createdAt: $createdAt, lastActivityAt: $lastActivityAt, kickedUsers: $kickedUsers, groupChat: $groupChat)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) _then) =
      _$ChatRoomCopyWithImpl;
  @useResult
  $Res call(
      {String roomId,
      String? title,
      List<int> participants,
      int? managerId,
      DateTime createdAt,
      DateTime lastActivityAt,
      List<int> kickedUsers,
      bool groupChat});
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res> implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._self, this._then);

  final ChatRoom _self;
  final $Res Function(ChatRoom) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? title = freezed,
    Object? participants = null,
    Object? managerId = freezed,
    Object? createdAt = null,
    Object? lastActivityAt = null,
    Object? kickedUsers = null,
    Object? groupChat = null,
  }) {
    return _then(ChatRoom(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      participants: null == participants
          ? _self.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<int>,
      managerId: freezed == managerId
          ? _self.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastActivityAt: null == lastActivityAt
          ? _self.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      kickedUsers: null == kickedUsers
          ? _self.kickedUsers
          : kickedUsers // ignore: cast_nullable_to_non_nullable
              as List<int>,
      groupChat: null == groupChat
          ? _self.groupChat
          : groupChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
