// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timetable {
  int get id;
  String get name;
  String get professor;
  String get location;
  WeekDay get week;
  String get startAt;
  String get endAt;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimetableCopyWith<Timetable> get copyWith =>
      _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Timetable &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.professor, professor) ||
                other.professor == professor) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, professor, location, week, startAt, endAt);

  @override
  String toString() {
    return 'Timetable(id: $id, name: $name, professor: $professor, location: $location, week: $week, startAt: $startAt, endAt: $endAt)';
  }
}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res> {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) =
      _$TimetableCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String name,
      String professor,
      String location,
      WeekDay week,
      String startAt,
      String endAt});
}

/// @nodoc
class _$TimetableCopyWithImpl<$Res> implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._self, this._then);

  final Timetable _self;
  final $Res Function(Timetable) _then;

  /// Create a copy of Timetable
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? professor = null,
    Object? location = null,
    Object? week = null,
    Object? startAt = null,
    Object? endAt = null,
  }) {
    return _then(Timetable(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      professor: null == professor
          ? _self.professor
          : professor // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      week: null == week
          ? _self.week
          : week // ignore: cast_nullable_to_non_nullable
              as WeekDay,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as String,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
