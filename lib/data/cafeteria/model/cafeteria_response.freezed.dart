// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cafeteria_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CafeteriaResponse {
  String get startDate;
  String get endDate;
  List<DailyMealModel> get dailyMeals;

  /// Create a copy of CafeteriaResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CafeteriaResponseCopyWith<CafeteriaResponse> get copyWith =>
      _$CafeteriaResponseCopyWithImpl<CafeteriaResponse>(
          this as CafeteriaResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CafeteriaResponse &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other.dailyMeals, dailyMeals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate,
      const DeepCollectionEquality().hash(dailyMeals));

  @override
  String toString() {
    return 'CafeteriaResponse(startDate: $startDate, endDate: $endDate, dailyMeals: $dailyMeals)';
  }
}

/// @nodoc
abstract mixin class $CafeteriaResponseCopyWith<$Res> {
  factory $CafeteriaResponseCopyWith(
          CafeteriaResponse value, $Res Function(CafeteriaResponse) _then) =
      _$CafeteriaResponseCopyWithImpl;
  @useResult
  $Res call(
      {String startDate, String endDate, List<DailyMealModel> dailyMeals});
}

/// @nodoc
class _$CafeteriaResponseCopyWithImpl<$Res>
    implements $CafeteriaResponseCopyWith<$Res> {
  _$CafeteriaResponseCopyWithImpl(this._self, this._then);

  final CafeteriaResponse _self;
  final $Res Function(CafeteriaResponse) _then;

  /// Create a copy of CafeteriaResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? dailyMeals = null,
  }) {
    return _then(CafeteriaResponse(
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      dailyMeals: null == dailyMeals
          ? _self.dailyMeals
          : dailyMeals // ignore: cast_nullable_to_non_nullable
              as List<DailyMealModel>,
    ));
  }
}

// dart format on
