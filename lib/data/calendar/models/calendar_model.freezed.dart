// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarModel {
  String get title;
  String get location;
  DateTime get startAt;
  DateTime get endAt;

  /// Create a copy of CalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarModelCopyWith<CalendarModel> get copyWith =>
      _$CalendarModelCopyWithImpl<CalendarModel>(
          this as CalendarModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, location, startAt, endAt);

  @override
  String toString() {
    return 'CalendarModel(title: $title, location: $location, startAt: $startAt, endAt: $endAt)';
  }
}

/// @nodoc
abstract mixin class $CalendarModelCopyWith<$Res> {
  factory $CalendarModelCopyWith(
          CalendarModel value, $Res Function(CalendarModel) _then) =
      _$CalendarModelCopyWithImpl;
  @useResult
  $Res call({String title, String location, DateTime startAt, DateTime endAt});
}

/// @nodoc
class _$CalendarModelCopyWithImpl<$Res>
    implements $CalendarModelCopyWith<$Res> {
  _$CalendarModelCopyWithImpl(this._self, this._then);

  final CalendarModel _self;
  final $Res Function(CalendarModel) _then;

  /// Create a copy of CalendarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? location = null,
    Object? startAt = null,
    Object? endAt = null,
  }) {
    return _then(CalendarModel(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
