// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_table_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeTableItemResponse {
  String get title;
  String get startAt;
  String get endAt;

  /// Create a copy of TimeTableItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimeTableItemResponseCopyWith<TimeTableItemResponse> get copyWith =>
      _$TimeTableItemResponseCopyWithImpl<TimeTableItemResponse>(
          this as TimeTableItemResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimeTableItemResponse &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, startAt, endAt);

  @override
  String toString() {
    return 'TimeTableItemResponse(title: $title, startAt: $startAt, endAt: $endAt)';
  }
}

/// @nodoc
abstract mixin class $TimeTableItemResponseCopyWith<$Res> {
  factory $TimeTableItemResponseCopyWith(TimeTableItemResponse value,
          $Res Function(TimeTableItemResponse) _then) =
      _$TimeTableItemResponseCopyWithImpl;
  @useResult
  $Res call({String title, String startAt, String endAt});
}

/// @nodoc
class _$TimeTableItemResponseCopyWithImpl<$Res>
    implements $TimeTableItemResponseCopyWith<$Res> {
  _$TimeTableItemResponseCopyWithImpl(this._self, this._then);

  final TimeTableItemResponse _self;
  final $Res Function(TimeTableItemResponse) _then;

  /// Create a copy of TimeTableItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? startAt = null,
    Object? endAt = null,
  }) {
    return _then(TimeTableItemResponse(
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
    ));
  }
}

// dart format on
