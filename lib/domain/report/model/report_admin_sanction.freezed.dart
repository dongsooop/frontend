// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_admin_sanction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportAdminSanction {
  int get id;
  String get reporterNickname;
  String get reportType;
  int get targetId;
  int? get targetMemberId;
  String get reportReason;
  String? get description;
  String? get adminNickname;
  String? get sanctionType;
  String? get sanctionReason;
  String? get sanctionStartDate;
  String? get sanctionEndDate;
  String get createdAt;

  /// Create a copy of ReportAdminSanction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportAdminSanctionCopyWith<ReportAdminSanction> get copyWith =>
      _$ReportAdminSanctionCopyWithImpl<ReportAdminSanction>(
          this as ReportAdminSanction, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportAdminSanction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterNickname, reporterNickname) ||
                other.reporterNickname == reporterNickname) &&
            (identical(other.reportType, reportType) ||
                other.reportType == reportType) &&
            (identical(other.targetId, targetId) ||
                other.targetId == targetId) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.adminNickname, adminNickname) ||
                other.adminNickname == adminNickname) &&
            (identical(other.sanctionType, sanctionType) ||
                other.sanctionType == sanctionType) &&
            (identical(other.sanctionReason, sanctionReason) ||
                other.sanctionReason == sanctionReason) &&
            (identical(other.sanctionStartDate, sanctionStartDate) ||
                other.sanctionStartDate == sanctionStartDate) &&
            (identical(other.sanctionEndDate, sanctionEndDate) ||
                other.sanctionEndDate == sanctionEndDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reporterNickname,
      reportType,
      targetId,
      targetMemberId,
      reportReason,
      description,
      adminNickname,
      sanctionType,
      sanctionReason,
      sanctionStartDate,
      sanctionEndDate,
      createdAt);

  @override
  String toString() {
    return 'ReportAdminSanction(id: $id, reporterNickname: $reporterNickname, reportType: $reportType, targetId: $targetId, targetMemberId: $targetMemberId, reportReason: $reportReason, description: $description, adminNickname: $adminNickname, sanctionType: $sanctionType, sanctionReason: $sanctionReason, sanctionStartDate: $sanctionStartDate, sanctionEndDate: $sanctionEndDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ReportAdminSanctionCopyWith<$Res> {
  factory $ReportAdminSanctionCopyWith(
          ReportAdminSanction value, $Res Function(ReportAdminSanction) _then) =
      _$ReportAdminSanctionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String reporterNickname,
      String reportType,
      int targetId,
      int? targetMemberId,
      String reportReason,
      String? description,
      String? adminNickname,
      String? sanctionType,
      String? sanctionReason,
      String? sanctionStartDate,
      String? sanctionEndDate,
      String createdAt});
}

/// @nodoc
class _$ReportAdminSanctionCopyWithImpl<$Res>
    implements $ReportAdminSanctionCopyWith<$Res> {
  _$ReportAdminSanctionCopyWithImpl(this._self, this._then);

  final ReportAdminSanction _self;
  final $Res Function(ReportAdminSanction) _then;

  /// Create a copy of ReportAdminSanction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterNickname = null,
    Object? reportType = null,
    Object? targetId = null,
    Object? targetMemberId = freezed,
    Object? reportReason = null,
    Object? description = freezed,
    Object? adminNickname = freezed,
    Object? sanctionType = freezed,
    Object? sanctionReason = freezed,
    Object? sanctionStartDate = freezed,
    Object? sanctionEndDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(ReportAdminSanction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      reporterNickname: null == reporterNickname
          ? _self.reporterNickname
          : reporterNickname // ignore: cast_nullable_to_non_nullable
              as String,
      reportType: null == reportType
          ? _self.reportType
          : reportType // ignore: cast_nullable_to_non_nullable
              as String,
      targetId: null == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
      reportReason: null == reportReason
          ? _self.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNickname: freezed == adminNickname
          ? _self.adminNickname
          : adminNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      sanctionType: freezed == sanctionType
          ? _self.sanctionType
          : sanctionType // ignore: cast_nullable_to_non_nullable
              as String?,
      sanctionReason: freezed == sanctionReason
          ? _self.sanctionReason
          : sanctionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      sanctionStartDate: freezed == sanctionStartDate
          ? _self.sanctionStartDate
          : sanctionStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      sanctionEndDate: freezed == sanctionEndDate
          ? _self.sanctionEndDate
          : sanctionEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
