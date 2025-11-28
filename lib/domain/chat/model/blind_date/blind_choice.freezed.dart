// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_choice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindChoice {
  String? get sessionId;
  int get choicerId;
  int? get targetId;

  /// Create a copy of BlindChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindChoiceCopyWith<BlindChoice> get copyWith =>
      _$BlindChoiceCopyWithImpl<BlindChoice>(this as BlindChoice, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindChoice &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.choicerId, choicerId) ||
                other.choicerId == choicerId) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sessionId, choicerId, targetId);

  @override
  String toString() {
    return 'BlindChoice(sessionId: $sessionId, choicerId: $choicerId, targetId: $targetId)';
  }
}

/// @nodoc
abstract mixin class $BlindChoiceCopyWith<$Res> {
  factory $BlindChoiceCopyWith(
          BlindChoice value, $Res Function(BlindChoice) _then) =
      _$BlindChoiceCopyWithImpl;
  @useResult
  $Res call({String? sessionId, int choicerId, int? targetId});
}

/// @nodoc
class _$BlindChoiceCopyWithImpl<$Res> implements $BlindChoiceCopyWith<$Res> {
  _$BlindChoiceCopyWithImpl(this._self, this._then);

  final BlindChoice _self;
  final $Res Function(BlindChoice) _then;

  /// Create a copy of BlindChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = freezed,
    Object? choicerId = null,
    Object? targetId = freezed,
  }) {
    return _then(BlindChoice(
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      choicerId: null == choicerId
          ? _self.choicerId
          : choicerId // ignore: cast_nullable_to_non_nullable
              as int,
      targetId: freezed == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BlindChoice].
extension BlindChoicePatterns on BlindChoice {
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
