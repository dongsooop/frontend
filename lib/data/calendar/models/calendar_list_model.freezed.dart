// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarListModel {
  int? get id;
  String get title;
  String get location;
  DateTime get startAt;
  DateTime get endAt;
  String get type;

  /// Create a copy of CalendarListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CalendarListModelCopyWith<CalendarListModel> get copyWith =>
      _$CalendarListModelCopyWithImpl<CalendarListModel>(
          this as CalendarListModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CalendarListModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, location, startAt, endAt, type);

  @override
  String toString() {
    return 'CalendarListModel(id: $id, title: $title, location: $location, startAt: $startAt, endAt: $endAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CalendarListModelCopyWith<$Res> {
  factory $CalendarListModelCopyWith(
          CalendarListModel value, $Res Function(CalendarListModel) _then) =
      _$CalendarListModelCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      String title,
      String location,
      DateTime startAt,
      DateTime endAt,
      String type});
}

/// @nodoc
class _$CalendarListModelCopyWithImpl<$Res>
    implements $CalendarListModelCopyWith<$Res> {
  _$CalendarListModelCopyWithImpl(this._self, this._then);

  final CalendarListModel _self;
  final $Res Function(CalendarListModel) _then;

  /// Create a copy of CalendarListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? location = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? type = null,
  }) {
    return _then(CalendarListModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
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
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
