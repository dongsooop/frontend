// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_date_open_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlindDateOpenRequest {
  DateTime get expiredDate;
  int get maxSessionMemberCount;

  /// Create a copy of BlindDateOpenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlindDateOpenRequestCopyWith<BlindDateOpenRequest> get copyWith =>
      _$BlindDateOpenRequestCopyWithImpl<BlindDateOpenRequest>(
          this as BlindDateOpenRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlindDateOpenRequest &&
            (identical(other.expiredDate, expiredDate) ||
                other.expiredDate == expiredDate) &&
            (identical(other.maxSessionMemberCount, maxSessionMemberCount) ||
                other.maxSessionMemberCount == maxSessionMemberCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, expiredDate, maxSessionMemberCount);

  @override
  String toString() {
    return 'BlindDateOpenRequest(expiredDate: $expiredDate, maxSessionMemberCount: $maxSessionMemberCount)';
  }
}

/// @nodoc
abstract mixin class $BlindDateOpenRequestCopyWith<$Res> {
  factory $BlindDateOpenRequestCopyWith(BlindDateOpenRequest value,
          $Res Function(BlindDateOpenRequest) _then) =
      _$BlindDateOpenRequestCopyWithImpl;
  @useResult
  $Res call({DateTime expiredDate, int maxSessionMemberCount});
}

/// @nodoc
class _$BlindDateOpenRequestCopyWithImpl<$Res>
    implements $BlindDateOpenRequestCopyWith<$Res> {
  _$BlindDateOpenRequestCopyWithImpl(this._self, this._then);

  final BlindDateOpenRequest _self;
  final $Res Function(BlindDateOpenRequest) _then;

  /// Create a copy of BlindDateOpenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expiredDate = null,
    Object? maxSessionMemberCount = null,
  }) {
    return _then(BlindDateOpenRequest(
      expiredDate: null == expiredDate
          ? _self.expiredDate
          : expiredDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxSessionMemberCount: null == maxSessionMemberCount
          ? _self.maxSessionMemberCount
          : maxSessionMemberCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [BlindDateOpenRequest].
extension BlindDateOpenRequestPatterns on BlindDateOpenRequest {
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
