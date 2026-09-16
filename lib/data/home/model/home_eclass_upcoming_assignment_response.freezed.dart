// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_eclass_upcoming_assignment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeEclassUpcomingAssignmentResponse {
  String get courseName;
  String get title;
  DateTime get dueAt;
  int get dDay;
  bool get submitted;

  /// Create a copy of HomeEclassUpcomingAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeEclassUpcomingAssignmentResponseCopyWith<
          HomeEclassUpcomingAssignmentResponse>
      get copyWith => _$HomeEclassUpcomingAssignmentResponseCopyWithImpl<
              HomeEclassUpcomingAssignmentResponse>(
          this as HomeEclassUpcomingAssignmentResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeEclassUpcomingAssignmentResponse &&
            (identical(other.courseName, courseName) ||
                other.courseName == courseName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.dDay, dDay) || other.dDay == dDay) &&
            (identical(other.submitted, submitted) ||
                other.submitted == submitted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, courseName, title, dueAt, dDay, submitted);

  @override
  String toString() {
    return 'HomeEclassUpcomingAssignmentResponse(courseName: $courseName, title: $title, dueAt: $dueAt, dDay: $dDay, submitted: $submitted)';
  }
}

/// @nodoc
abstract mixin class $HomeEclassUpcomingAssignmentResponseCopyWith<$Res> {
  factory $HomeEclassUpcomingAssignmentResponseCopyWith(
          HomeEclassUpcomingAssignmentResponse value,
          $Res Function(HomeEclassUpcomingAssignmentResponse) _then) =
      _$HomeEclassUpcomingAssignmentResponseCopyWithImpl;
  @useResult
  $Res call(
      {String courseName,
      String title,
      DateTime dueAt,
      int dDay,
      bool submitted});
}

/// @nodoc
class _$HomeEclassUpcomingAssignmentResponseCopyWithImpl<$Res>
    implements $HomeEclassUpcomingAssignmentResponseCopyWith<$Res> {
  _$HomeEclassUpcomingAssignmentResponseCopyWithImpl(this._self, this._then);

  final HomeEclassUpcomingAssignmentResponse _self;
  final $Res Function(HomeEclassUpcomingAssignmentResponse) _then;

  /// Create a copy of HomeEclassUpcomingAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseName = null,
    Object? title = null,
    Object? dueAt = null,
    Object? dDay = null,
    Object? submitted = null,
  }) {
    return _then(HomeEclassUpcomingAssignmentResponse(
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
      dDay: null == dDay
          ? _self.dDay
          : dDay // ignore: cast_nullable_to_non_nullable
              as int,
      submitted: null == submitted
          ? _self.submitted
          : submitted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeEclassUpcomingAssignmentResponse].
extension HomeEclassUpcomingAssignmentResponsePatterns
    on HomeEclassUpcomingAssignmentResponse {
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
