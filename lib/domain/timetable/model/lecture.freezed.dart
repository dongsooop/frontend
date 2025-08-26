// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lecture.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lecture {
  int get id;
  String get name;
  String get professor;
  String get location;
  WeekDay get week;
  String get startAt;
  String get endAt;

  /// Create a copy of Lecture
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LectureCopyWith<Lecture> get copyWith =>
      _$LectureCopyWithImpl<Lecture>(this as Lecture, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Lecture &&
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
    return 'Lecture(id: $id, name: $name, professor: $professor, location: $location, week: $week, startAt: $startAt, endAt: $endAt)';
  }
}

/// @nodoc
abstract mixin class $LectureCopyWith<$Res> {
  factory $LectureCopyWith(Lecture value, $Res Function(Lecture) _then) =
      _$LectureCopyWithImpl;
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
class _$LectureCopyWithImpl<$Res> implements $LectureCopyWith<$Res> {
  _$LectureCopyWithImpl(this._self, this._then);

  final Lecture _self;
  final $Res Function(Lecture) _then;

  /// Create a copy of Lecture
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
    return _then(Lecture(
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
