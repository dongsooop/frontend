// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_eclass_assignment_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeEclassAssignmentResponse {
  bool get linked;
  String? get status;
  int get upcomingCount;
  List<HomeEclassUpcomingAssignmentResponse>? get upcoming;
  String? get nearestCourseName;
  String? get nearestTitle;
  DateTime? get nearestDueAt;
  int? get nearestDDay;

  /// Create a copy of HomeEclassAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeEclassAssignmentResponseCopyWith<HomeEclassAssignmentResponse>
      get copyWith => _$HomeEclassAssignmentResponseCopyWithImpl<
              HomeEclassAssignmentResponse>(
          this as HomeEclassAssignmentResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeEclassAssignmentResponse &&
            (identical(other.linked, linked) || other.linked == linked) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.upcomingCount, upcomingCount) ||
                other.upcomingCount == upcomingCount) &&
            const DeepCollectionEquality().equals(other.upcoming, upcoming) &&
            (identical(other.nearestCourseName, nearestCourseName) ||
                other.nearestCourseName == nearestCourseName) &&
            (identical(other.nearestTitle, nearestTitle) ||
                other.nearestTitle == nearestTitle) &&
            (identical(other.nearestDueAt, nearestDueAt) ||
                other.nearestDueAt == nearestDueAt) &&
            (identical(other.nearestDDay, nearestDDay) ||
                other.nearestDDay == nearestDDay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      linked,
      status,
      upcomingCount,
      const DeepCollectionEquality().hash(upcoming),
      nearestCourseName,
      nearestTitle,
      nearestDueAt,
      nearestDDay);

  @override
  String toString() {
    return 'HomeEclassAssignmentResponse(linked: $linked, status: $status, upcomingCount: $upcomingCount, upcoming: $upcoming, nearestCourseName: $nearestCourseName, nearestTitle: $nearestTitle, nearestDueAt: $nearestDueAt, nearestDDay: $nearestDDay)';
  }
}

/// @nodoc
abstract mixin class $HomeEclassAssignmentResponseCopyWith<$Res> {
  factory $HomeEclassAssignmentResponseCopyWith(
          HomeEclassAssignmentResponse value,
          $Res Function(HomeEclassAssignmentResponse) _then) =
      _$HomeEclassAssignmentResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool linked,
      String? status,
      int upcomingCount,
      List<HomeEclassUpcomingAssignmentResponse>? upcoming,
      String? nearestCourseName,
      String? nearestTitle,
      DateTime? nearestDueAt,
      int? nearestDDay});
}

/// @nodoc
class _$HomeEclassAssignmentResponseCopyWithImpl<$Res>
    implements $HomeEclassAssignmentResponseCopyWith<$Res> {
  _$HomeEclassAssignmentResponseCopyWithImpl(this._self, this._then);

  final HomeEclassAssignmentResponse _self;
  final $Res Function(HomeEclassAssignmentResponse) _then;

  /// Create a copy of HomeEclassAssignmentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? linked = null,
    Object? status = freezed,
    Object? upcomingCount = null,
    Object? upcoming = freezed,
    Object? nearestCourseName = freezed,
    Object? nearestTitle = freezed,
    Object? nearestDueAt = freezed,
    Object? nearestDDay = freezed,
  }) {
    return _then(HomeEclassAssignmentResponse(
      linked: null == linked
          ? _self.linked
          : linked // ignore: cast_nullable_to_non_nullable
              as bool,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      upcomingCount: null == upcomingCount
          ? _self.upcomingCount
          : upcomingCount // ignore: cast_nullable_to_non_nullable
              as int,
      upcoming: freezed == upcoming
          ? _self.upcoming
          : upcoming // ignore: cast_nullable_to_non_nullable
              as List<HomeEclassUpcomingAssignmentResponse>?,
      nearestCourseName: freezed == nearestCourseName
          ? _self.nearestCourseName
          : nearestCourseName // ignore: cast_nullable_to_non_nullable
              as String?,
      nearestTitle: freezed == nearestTitle
          ? _self.nearestTitle
          : nearestTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      nearestDueAt: freezed == nearestDueAt
          ? _self.nearestDueAt
          : nearestDueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nearestDDay: freezed == nearestDDay
          ? _self.nearestDDay
          : nearestDDay // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeEclassAssignmentResponse].
extension HomeEclassAssignmentResponsePatterns on HomeEclassAssignmentResponse {
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
