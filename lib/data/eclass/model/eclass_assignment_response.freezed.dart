// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eclass_assignment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EclassAssignmentResponse {
  int get id;
  int get assignId;
  String get courseName;
  String get title;
  DateTime get dueAt;
  DateTime? get cutoffAt;
  int get dDay;
  bool get submitted;
  String get link;

  /// Create a copy of EclassAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EclassAssignmentResponseCopyWith<EclassAssignmentResponse> get copyWith =>
      _$EclassAssignmentResponseCopyWithImpl<EclassAssignmentResponse>(
          this as EclassAssignmentResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EclassAssignmentResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assignId, assignId) ||
                other.assignId == assignId) &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.cutoffAt, cutoffAt) ||
                other.cutoffAt == cutoffAt) &&
            (identical(other.dDay, dDay) || other.dDay == dDay) &&
            (identical(other.submitted, submitted) ||
                other.submitted == submitted) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assignId, courseName, title,
      dueAt, cutoffAt, dDay, submitted, link);

  @override
  String toString() {
    return 'EclassAssignmentResponse(id: $id, assignId: $assignId, courseName: $courseName, title: $title, dueAt: $dueAt, cutoffAt: $cutoffAt, dDay: $dDay, submitted: $submitted, link: $link)';
  }
}

/// @nodoc
abstract mixin class $EclassAssignmentResponseCopyWith<$Res> {
  factory $EclassAssignmentResponseCopyWith(EclassAssignmentResponse value,
          $Res Function(EclassAssignmentResponse) _then) =
      _$EclassAssignmentResponseCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int assignId,
      String courseName,
      String title,
      DateTime dueAt,
      DateTime? cutoffAt,
      int dDay,
      bool submitted,
      String link});
}

/// @nodoc
class _$EclassAssignmentResponseCopyWithImpl<$Res>
    implements $EclassAssignmentResponseCopyWith<$Res> {
  _$EclassAssignmentResponseCopyWithImpl(this._self, this._then);

  final EclassAssignmentResponse _self;
  final $Res Function(EclassAssignmentResponse) _then;

  /// Create a copy of EclassAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assignId = null,
    Object? courseName = null,
    Object? title = null,
    Object? dueAt = null,
    Object? cutoffAt = freezed,
    Object? dDay = null,
    Object? submitted = null,
    Object? link = null,
  }) {
    return _then(EclassAssignmentResponse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      assignId: null == assignId
          ? _self.assignId
          : assignId // ignore: cast_nullable_to_non_nullable
              as int,
      courseName: null == courseName
          ? _self.courseName
          : courseName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      dueAt: null == dueAt
          ? _self.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cutoffAt: freezed == cutoffAt
          ? _self.cutoffAt
          : cutoffAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dDay: null == dDay
          ? _self.dDay
          : dDay // ignore: cast_nullable_to_non_nullable
              as int,
      submitted: null == submitted
          ? _self.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as bool,
      link: null == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [EclassAssignmentResponse].
extension EclassAssignmentResponsePatterns on EclassAssignmentResponse {
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
