// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeResponse {
  List<TimeTableItemResponse> get timeTableItems;
  List<ScheduleItemResponse> get scheduleItems;
  List<NewNoticeItemResponse> get newNoticeItems;
  List<PopularRecruitItemResponse> get popularRecruitItems;

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeResponseCopyWith<HomeResponse> get copyWith =>
      _$HomeResponseCopyWithImpl<HomeResponse>(
          this as HomeResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeResponse &&
            const DeepCollectionEquality()
                .equals(other.timeTableItems, timeTableItems) &&
            const DeepCollectionEquality()
                .equals(other.scheduleItems, scheduleItems) &&
            const DeepCollectionEquality()
                .equals(other.newNoticeItems, newNoticeItems) &&
            const DeepCollectionEquality()
                .equals(other.popularRecruitItems, popularRecruitItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(timeTableItems),
      const DeepCollectionEquality().hash(scheduleItems),
      const DeepCollectionEquality().hash(newNoticeItems),
      const DeepCollectionEquality().hash(popularRecruitItems));

  @override
  String toString() {
    return 'HomeResponse(timeTableItems: $timeTableItems, scheduleItems: $scheduleItems, newNoticeItems: $newNoticeItems, popularRecruitItems: $popularRecruitItems)';
  }
}

/// @nodoc
abstract mixin class $HomeResponseCopyWith<$Res> {
  factory $HomeResponseCopyWith(
          HomeResponse value, $Res Function(HomeResponse) _then) =
      _$HomeResponseCopyWithImpl;
  @useResult
  $Res call(
      {List<TimeTableItemResponse> timeTableItems,
      List<ScheduleItemResponse> scheduleItems,
      List<NewNoticeItemResponse> newNoticeItems,
      List<PopularRecruitItemResponse> popularRecruitItems});
}

/// @nodoc
class _$HomeResponseCopyWithImpl<$Res> implements $HomeResponseCopyWith<$Res> {
  _$HomeResponseCopyWithImpl(this._self, this._then);

  final HomeResponse _self;
  final $Res Function(HomeResponse) _then;

  /// Create a copy of HomeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeTableItems = null,
    Object? scheduleItems = null,
    Object? newNoticeItems = null,
    Object? popularRecruitItems = null,
  }) {
    return _then(HomeResponse(
      timeTableItems: null == timeTableItems
          ? _self.timeTableItems
          : timeTableItems // ignore: cast_nullable_to_non_nullable
              as List<TimeTableItemResponse>,
      scheduleItems: null == scheduleItems
          ? _self.scheduleItems
          : scheduleItems // ignore: cast_nullable_to_non_nullable
              as List<ScheduleItemResponse>,
      newNoticeItems: null == newNoticeItems
          ? _self.newNoticeItems
          : newNoticeItems // ignore: cast_nullable_to_non_nullable
              as List<NewNoticeItemResponse>,
      popularRecruitItems: null == popularRecruitItems
          ? _self.popularRecruitItems
          : popularRecruitItems // ignore: cast_nullable_to_non_nullable
              as List<PopularRecruitItemResponse>,
    ));
  }
}

// dart format on
