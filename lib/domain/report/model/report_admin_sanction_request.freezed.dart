// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_admin_sanction_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportAdminSanctionRequest {
  int get reportId;
  int get targetMemberId;
  SanctionType get sanctionType;
  String get sanctionReason;
  DateTime? get sanctionEndAt;

  /// Create a copy of ReportAdminSanctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportAdminSanctionRequestCopyWith<ReportAdminSanctionRequest>
      get copyWith =>
          _$ReportAdminSanctionRequestCopyWithImpl<ReportAdminSanctionRequest>(
              this as ReportAdminSanctionRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportAdminSanctionRequest &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId) &&
            (identical(other.sanctionType, sanctionType) ||
                other.sanctionType == sanctionType) &&
            (identical(other.sanctionReason, sanctionReason) ||
                other.sanctionReason == sanctionReason) &&
            (identical(other.sanctionEndAt, sanctionEndAt) ||
                other.sanctionEndAt == sanctionEndAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reportId, targetMemberId,
      sanctionType, sanctionReason, sanctionEndAt);

  @override
  String toString() {
    return 'ReportAdminSanctionRequest(reportId: $reportId, targetMemberId: $targetMemberId, sanctionType: $sanctionType, sanctionReason: $sanctionReason, sanctionEndAt: $sanctionEndAt)';
  }
}

/// @nodoc
abstract mixin class $ReportAdminSanctionRequestCopyWith<$Res> {
  factory $ReportAdminSanctionRequestCopyWith(ReportAdminSanctionRequest value,
          $Res Function(ReportAdminSanctionRequest) _then) =
      _$ReportAdminSanctionRequestCopyWithImpl;
  @useResult
  $Res call(
      {int reportId,
      int targetMemberId,
      SanctionType sanctionType,
      String sanctionReason,
      DateTime? sanctionEndAt});
}

/// @nodoc
class _$ReportAdminSanctionRequestCopyWithImpl<$Res>
    implements $ReportAdminSanctionRequestCopyWith<$Res> {
  _$ReportAdminSanctionRequestCopyWithImpl(this._self, this._then);

  final ReportAdminSanctionRequest _self;
  final $Res Function(ReportAdminSanctionRequest) _then;

  /// Create a copy of ReportAdminSanctionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? targetMemberId = null,
    Object? sanctionType = null,
    Object? sanctionReason = null,
    Object? sanctionEndAt = freezed,
  }) {
    return _then(ReportAdminSanctionRequest(
      reportId: null == reportId
          ? _self.reportId
          : reportId // ignore: cast_nullable_to_non_nullable
              as int,
      targetMemberId: null == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int,
      sanctionType: null == sanctionType
          ? _self.sanctionType
          : sanctionType // ignore: cast_nullable_to_non_nullable
              as SanctionType,
      sanctionReason: null == sanctionReason
          ? _self.sanctionReason
          : sanctionReason // ignore: cast_nullable_to_non_nullable
              as String,
      sanctionEndAt: freezed == sanctionEndAt
          ? _self.sanctionEndAt
          : sanctionEndAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReportAdminSanctionRequest].
extension ReportAdminSanctionRequestPatterns on ReportAdminSanctionRequest {
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
