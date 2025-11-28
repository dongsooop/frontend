// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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
  RecruitType get boardType;
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
            (identical(other.boardType, boardType) ||
                other.boardType == boardType) &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.boardTitle, boardTitle) ||
                other.boardTitle == boardTitle));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, targetUserId, boardType, boardId, boardTitle);

  @override
  String toString() {
    return 'ChatRoomRequest(targetUserId: $targetUserId, boardType: $boardType, boardId: $boardId, boardTitle: $boardTitle)';
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
      RecruitType boardType,
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
    Object? boardType = null,
    Object? boardId = null,
    Object? boardTitle = null,
  }) {
    return _then(ChatRoomRequest(
      targetUserId: null == targetUserId
          ? _self.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as int,
      boardType: null == boardType
          ? _self.boardType
          : boardType // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [ChatRoomRequest].
extension ChatRoomRequestPatterns on ChatRoomRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on
