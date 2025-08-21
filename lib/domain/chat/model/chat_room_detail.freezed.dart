// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomDetail {
  String get roomId;
  String get title;
  List<int> get participants;
  int? get managerId;
  bool get groupChat;

  /// Create a copy of ChatRoomDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomDetailCopyWith<ChatRoomDetail> get copyWith =>
      _$ChatRoomDetailCopyWithImpl<ChatRoomDetail>(
          this as ChatRoomDetail, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoomDetail &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.participants, participants) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.groupChat, groupChat) ||
                other.groupChat == groupChat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roomId, title,
      const DeepCollectionEquality().hash(participants), managerId, groupChat);

  @override
  String toString() {
    return 'ChatRoomDetail(roomId: $roomId, title: $title, participants: $participants, managerId: $managerId, groupChat: $groupChat)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomDetailCopyWith<$Res> {
  factory $ChatRoomDetailCopyWith(
          ChatRoomDetail value, $Res Function(ChatRoomDetail) _then) =
      _$ChatRoomDetailCopyWithImpl;
  @useResult
  $Res call(
      {String roomId,
      String title,
      List<int> participants,
      int? managerId,
      bool groupChat});
}

/// @nodoc
class _$ChatRoomDetailCopyWithImpl<$Res>
    implements $ChatRoomDetailCopyWith<$Res> {
  _$ChatRoomDetailCopyWithImpl(this._self, this._then);

  final ChatRoomDetail _self;
  final $Res Function(ChatRoomDetail) _then;

  /// Create a copy of ChatRoomDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? title = null,
    Object? participants = null,
    Object? managerId = freezed,
    Object? groupChat = null,
  }) {
    return _then(ChatRoomDetail(
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      participants: null == participants
          ? _self.participants
          : participants // ignore: cast_nullable_to_non_nullable
              as List<int>,
      managerId: freezed == managerId
          ? _self.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as int?,
      groupChat: null == groupChat
          ? _self.groupChat
          : groupChat // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
