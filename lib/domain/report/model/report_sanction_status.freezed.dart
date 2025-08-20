// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_sanction_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportSanctionStatus {
  String get reason;
  String get description;
  String get startDate;
  String get endDate;

  /// Create a copy of ReportSanctionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportSanctionStatusCopyWith<ReportSanctionStatus> get copyWith =>
      _$ReportSanctionStatusCopyWithImpl<ReportSanctionStatus>(
          this as ReportSanctionStatus, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportSanctionStatus &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, reason, description, startDate, endDate);

  @override
  String toString() {
    return 'ReportSanctionStatus(reason: $reason, description: $description, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $ReportSanctionStatusCopyWith<$Res> {
  factory $ReportSanctionStatusCopyWith(ReportSanctionStatus value,
          $Res Function(ReportSanctionStatus) _then) =
      _$ReportSanctionStatusCopyWithImpl;
  @useResult
  $Res call(
      {String reason, String startDate, String endDate, String description});
}

/// @nodoc
class _$ReportSanctionStatusCopyWithImpl<$Res>
    implements $ReportSanctionStatusCopyWith<$Res> {
  _$ReportSanctionStatusCopyWithImpl(this._self, this._then);

  final ReportSanctionStatus _self;
  final $Res Function(ReportSanctionStatus) _then;

  /// Create a copy of ReportSanctionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? description = null,
  }) {
    return _then(ReportSanctionStatus(
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
