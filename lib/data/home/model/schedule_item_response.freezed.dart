// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleItemResponse {
  String get title;
  String get startAt;
  String get endAt;
  String get type;

  /// Create a copy of ScheduleItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleItemResponseCopyWith<ScheduleItemResponse> get copyWith =>
      _$ScheduleItemResponseCopyWithImpl<ScheduleItemResponse>(
          this as ScheduleItemResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduleItemResponse &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, startAt, endAt, type);

  @override
  String toString() {
    return 'ScheduleItemResponse(title: $title, startAt: $startAt, endAt: $endAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ScheduleItemResponseCopyWith<$Res> {
  factory $ScheduleItemResponseCopyWith(ScheduleItemResponse value,
          $Res Function(ScheduleItemResponse) _then) =
      _$ScheduleItemResponseCopyWithImpl;
  @useResult
  $Res call({String title, String startAt, String endAt, String type});
}

/// @nodoc
class _$ScheduleItemResponseCopyWithImpl<$Res>
    implements $ScheduleItemResponseCopyWith<$Res> {
  _$ScheduleItemResponseCopyWithImpl(this._self, this._then);

  final ScheduleItemResponse _self;
  final $Res Function(ScheduleItemResponse) _then;

  /// Create a copy of ScheduleItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? type = null,
  }) {
    return _then(ScheduleItemResponse(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as String,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
