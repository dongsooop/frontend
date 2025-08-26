// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lecture_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LectureRequest {
  String get name;
  String get professor;
  String get location;
  WeekDay get week;
  String get startAt;
  String get endAt;
  int get year;
  String get semester;

  /// Create a copy of LectureRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LectureRequestCopyWith<LectureRequest> get copyWith =>
      _$LectureRequestCopyWithImpl<LectureRequest>(
          this as LectureRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LectureRequest &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.professor, professor) ||
                other.professor == professor) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.semester, semester) ||
                other.semester == semester));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, professor, location, week,
      startAt, endAt, year, semester);

  @override
  String toString() {
    return 'LectureRequest(name: $name, professor: $professor, location: $location, week: $week, startAt: $startAt, endAt: $endAt, year: $year, semester: $semester)';
  }
}

/// @nodoc
abstract mixin class $LectureRequestCopyWith<$Res> {
  factory $LectureRequestCopyWith(
          LectureRequest value, $Res Function(LectureRequest) _then) =
      _$LectureRequestCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String professor,
      String location,
      WeekDay week,
      String startAt,
      String endAt,
      int year,
      String semester});
}

/// @nodoc
class _$LectureRequestCopyWithImpl<$Res>
    implements $LectureRequestCopyWith<$Res> {
  _$LectureRequestCopyWithImpl(this._self, this._then);

  final LectureRequest _self;
  final $Res Function(LectureRequest) _then;

  /// Create a copy of LectureRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? professor = null,
    Object? location = null,
    Object? week = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? year = null,
    Object? semester = null,
  }) {
    return _then(LectureRequest(
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
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      semester: null == semester
          ? _self.semester
          : semester // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
