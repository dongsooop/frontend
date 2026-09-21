// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eclass_assignments_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EclassAssignmentsResponse {
  bool get linked;
  String? get status;
  List<EclassAssignmentResponse> get assignments;

  /// Create a copy of EclassAssignmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EclassAssignmentsResponseCopyWith<EclassAssignmentsResponse> get copyWith =>
      _$EclassAssignmentsResponseCopyWithImpl<EclassAssignmentsResponse>(
          this as EclassAssignmentsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EclassAssignmentsResponse &&
            (identical(other.linked, linked) || other.linked == linked) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.assignments, assignments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, linked, status,
      const DeepCollectionEquality().hash(assignments));

  @override
  String toString() {
    return 'EclassAssignmentsResponse(linked: $linked, status: $status, assignments: $assignments)';
  }
}

/// @nodoc
abstract mixin class $EclassAssignmentsResponseCopyWith<$Res> {
  factory $EclassAssignmentsResponseCopyWith(EclassAssignmentsResponse value,
          $Res Function(EclassAssignmentsResponse) _then) =
      _$EclassAssignmentsResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool linked,
      String? status,
      List<EclassAssignmentResponse> assignments});
}

/// @nodoc
class _$EclassAssignmentsResponseCopyWithImpl<$Res>
    implements $EclassAssignmentsResponseCopyWith<$Res> {
  _$EclassAssignmentsResponseCopyWithImpl(this._self, this._then);

  final EclassAssignmentsResponse _self;
  final $Res Function(EclassAssignmentsResponse) _then;

  /// Create a copy of EclassAssignmentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? linked = null,
    Object? status = freezed,
    Object? assignments = null,
  }) {
    return _then(EclassAssignmentsResponse(
      linked: null == linked
          ? _self.linked
          : linked // ignore: cast_nullable_to_non_nullable
              as bool,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      assignments: null == assignments
          ? _self.assignments
          : assignments // ignore: cast_nullable_to_non_nullable
              as List<EclassAssignmentResponse>,
    ));
  }
}

/// Adds pattern-matching-related methods to [EclassAssignmentsResponse].
extension EclassAssignmentsResponsePatterns on EclassAssignmentsResponse {
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
