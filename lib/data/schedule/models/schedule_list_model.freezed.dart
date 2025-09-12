// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleListModel {
  int? get id;
  String get title;
  String get location;
  DateTime get startAt;
  DateTime get endAt;
  String get type;

  /// Create a copy of ScheduleListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleListModelCopyWith<ScheduleListModel> get copyWith =>
      _$ScheduleListModelCopyWithImpl<ScheduleListModel>(
          this as ScheduleListModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduleListModel &&
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
    return 'ScheduleListModel(id: $id, title: $title, location: $location, startAt: $startAt, endAt: $endAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ScheduleListModelCopyWith<$Res> {
  factory $ScheduleListModelCopyWith(
          ScheduleListModel value, $Res Function(ScheduleListModel) _then) =
      _$ScheduleListModelCopyWithImpl;
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
class _$ScheduleListModelCopyWithImpl<$Res>
    implements $ScheduleListModelCopyWith<$Res> {
  _$ScheduleListModelCopyWithImpl(this._self, this._then);

  final ScheduleListModel _self;
  final $Res Function(ScheduleListModel) _then;

  /// Create a copy of ScheduleListModel
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
    return _then(ScheduleListModel(
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
