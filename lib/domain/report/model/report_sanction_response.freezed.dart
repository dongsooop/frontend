// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_sanction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportSanctionResponse {
  bool get isSanctioned;
  String? get sanctionType;
  String? get reason;
  DateTime? get startDate;
  DateTime? get endDate;
  String? get description;

  /// Create a copy of ReportSanctionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportSanctionResponseCopyWith<ReportSanctionResponse> get copyWith =>
      _$ReportSanctionResponseCopyWithImpl<ReportSanctionResponse>(
          this as ReportSanctionResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportSanctionResponse &&
            (identical(other.isSanctioned, isSanctioned) ||
                other.isSanctioned == isSanctioned) &&
            (identical(other.sanctionType, sanctionType) ||
                other.sanctionType == sanctionType) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isSanctioned, sanctionType,
      reason, startDate, endDate, description);

  @override
  String toString() {
    return 'ReportSanctionResponse(isSanctioned: $isSanctioned, sanctionType: $sanctionType, reason: $reason, startDate: $startDate, endDate: $endDate, description: $description)';
  }
}

/// @nodoc
abstract mixin class $ReportSanctionResponseCopyWith<$Res> {
  factory $ReportSanctionResponseCopyWith(ReportSanctionResponse value,
          $Res Function(ReportSanctionResponse) _then) =
      _$ReportSanctionResponseCopyWithImpl;
  @useResult
  $Res call(
      {bool isSanctioned,
      String? sanctionType,
      String? reason,
      DateTime? startDate,
      DateTime? endDate,
      String? description});
}

/// @nodoc
class _$ReportSanctionResponseCopyWithImpl<$Res>
    implements $ReportSanctionResponseCopyWith<$Res> {
  _$ReportSanctionResponseCopyWithImpl(this._self, this._then);

  final ReportSanctionResponse _self;
  final $Res Function(ReportSanctionResponse) _then;

  /// Create a copy of ReportSanctionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSanctioned = null,
    Object? sanctionType = freezed,
    Object? reason = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? description = freezed,
  }) {
    return _then(ReportSanctionResponse(
      isSanctioned: null == isSanctioned
          ? _self.isSanctioned
          : isSanctioned // ignore: cast_nullable_to_non_nullable
              as bool,
      sanctionType: freezed == sanctionType
          ? _self.sanctionType
          : sanctionType // ignore: cast_nullable_to_non_nullable
              as String?,
      reason: freezed == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
