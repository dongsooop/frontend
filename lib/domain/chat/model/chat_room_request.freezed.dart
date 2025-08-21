// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoomRequest {
  int get targetUserId;
  RecruitType get recruitType;
  int get boardId;
  String get boardTitle;

  /// Create a copy of ChatRoomRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomRequestCopyWith<ChatRoomRequest> get copyWith =>
      _$ChatRoomRequestCopyWithImpl<ChatRoomRequest>(
          this as ChatRoomRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoomRequest &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.recruitType, recruitType) ||
                other.recruitType == recruitType) &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.boardTitle, boardTitle) ||
                other.boardTitle == boardTitle));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, targetUserId, recruitType, boardId, boardTitle);

  @override
  String toString() {
    return 'ChatRoomRequest(targetUserId: $targetUserId, recruitType: $recruitType, boardId: $boardId, boardTitle: $boardTitle)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomRequestCopyWith<$Res> {
  factory $ChatRoomRequestCopyWith(
          ChatRoomRequest value, $Res Function(ChatRoomRequest) _then) =
      _$ChatRoomRequestCopyWithImpl;
  @useResult
  $Res call(
      {int targetUserId,
      RecruitType recruitType,
      int boardId,
      String boardTitle});
}

/// @nodoc
class _$ChatRoomRequestCopyWithImpl<$Res>
    implements $ChatRoomRequestCopyWith<$Res> {
  _$ChatRoomRequestCopyWithImpl(this._self, this._then);

  final ChatRoomRequest _self;
  final $Res Function(ChatRoomRequest) _then;

  /// Create a copy of ChatRoomRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetUserId = null,
    Object? recruitType = null,
    Object? boardId = null,
    Object? boardTitle = null,
  }) {
    return _then(ChatRoomRequest(
      targetUserId: null == targetUserId
          ? _self.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as int,
      recruitType: null == recruitType
          ? _self.recruitType
          : recruitType // ignore: cast_nullable_to_non_nullable
              as RecruitType,
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
      boardTitle: null == boardTitle
          ? _self.boardTitle
          : boardTitle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
