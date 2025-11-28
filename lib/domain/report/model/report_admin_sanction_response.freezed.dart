// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_admin_sanction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportAdminSanctionResponse {
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
  DateTime? get sanctionStartDate;
  DateTime? get sanctionEndDate;
  DateTime get createdAt;

  /// Create a copy of ReportAdminSanctionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportAdminSanctionResponseCopyWith<ReportAdminSanctionResponse>
      get copyWith => _$ReportAdminSanctionResponseCopyWithImpl<
              ReportAdminSanctionResponse>(
          this as ReportAdminSanctionResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportAdminSanctionResponse &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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
    return 'ReportAdminSanctionResponse(id: $id, reporterNickname: $reporterNickname, reportType: $reportType, targetId: $targetId, targetMemberId: $targetMemberId, reportReason: $reportReason, description: $description, adminNickname: $adminNickname, sanctionType: $sanctionType, sanctionReason: $sanctionReason, sanctionStartDate: $sanctionStartDate, sanctionEndDate: $sanctionEndDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ReportAdminSanctionResponseCopyWith<$Res> {
  factory $ReportAdminSanctionResponseCopyWith(
          ReportAdminSanctionResponse value,
          $Res Function(ReportAdminSanctionResponse) _then) =
      _$ReportAdminSanctionResponseCopyWithImpl;
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
      DateTime? sanctionStartDate,
      DateTime? sanctionEndDate,
      DateTime createdAt});
}

/// @nodoc
class _$ReportAdminSanctionResponseCopyWithImpl<$Res>
    implements $ReportAdminSanctionResponseCopyWith<$Res> {
  _$ReportAdminSanctionResponseCopyWithImpl(this._self, this._then);

  final ReportAdminSanctionResponse _self;
  final $Res Function(ReportAdminSanctionResponse) _then;

  /// Create a copy of ReportAdminSanctionResponse
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
    return _then(ReportAdminSanctionResponse(
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
              as DateTime?,
      sanctionEndDate: freezed == sanctionEndDate
          ? _self.sanctionEndDate
          : sanctionEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReportAdminSanctionResponse].
extension ReportAdminSanctionResponsePatterns on ReportAdminSanctionResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>() {
    final _that = this;
    switch (_that) {
      case _:
        return null;
    }
  }
}

// dart format on
