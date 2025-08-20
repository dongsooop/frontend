// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_write_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportWriteRequest {
  String get reportType;
  int get targetId;
  String get reason;
  String? get description;

  /// Create a copy of ReportWriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportWriteRequestCopyWith<ReportWriteRequest> get copyWith =>
      _$ReportWriteRequestCopyWithImpl<ReportWriteRequest>(
          this as ReportWriteRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportWriteRequest &&
            (identical(other.reportType, reportType) ||
                other.reportType == reportType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, reportType, targetId, reason, description);

  @override
  String toString() {
    return 'ReportWriteRequest(reportType: $reportType, targetId: $targetId, reason: $reason, description: $description)';
  }
}

/// @nodoc
abstract mixin class $ReportWriteRequestCopyWith<$Res> {
  factory $ReportWriteRequestCopyWith(
          ReportWriteRequest value, $Res Function(ReportWriteRequest) _then) =
      _$ReportWriteRequestCopyWithImpl;
  @useResult
  $Res call(
      {String reportType, int targetId, String reason, String? description});
}

/// @nodoc
class _$ReportWriteRequestCopyWithImpl<$Res>
    implements $ReportWriteRequestCopyWith<$Res> {
  _$ReportWriteRequestCopyWithImpl(this._self, this._then);

  final ReportWriteRequest _self;
  final $Res Function(ReportWriteRequest) _then;

  /// Create a copy of ReportWriteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportType = null,
    Object? targetId = null,
    Object? reason = null,
    Object? description = freezed,
  }) {
    return _then(ReportWriteRequest(
      reportType: null == reportType
          ? _self.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
