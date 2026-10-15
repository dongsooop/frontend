// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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
  int? get targetId;
  String? get targetUrl;
  int? get targetMemberId;
  String? get targetMemberNickname;
  String get reportReason;
  String? get description;
  bool get isProcessed;
  String? get adminNickname;
  String? get sanctionType;
  String? get sanctionReason;
  String? get sanctionStartDate;
  String? get sanctionEndDate;
  bool? get isSanctionActive;
  String? get chatRoomId;
  String? get messageId;
  String? get messageContent;
  String? get messageSentAt;
  List<ReportMessageContext> get messageContext;
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
            (identical(other.targetUrl, targetUrl) ||
                other.targetUrl == targetUrl) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId) &&
            (identical(other.targetMemberNickname, targetMemberNickname) ||
                other.targetMemberNickname == targetMemberNickname) &&
            (identical(other.reportReason, reportReason) ||
                other.reportReason == reportReason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
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
            (identical(other.isSanctionActive, isSanctionActive) ||
                other.isSanctionActive == isSanctionActive) &&
            (identical(other.chatRoomId, chatRoomId) ||
                other.chatRoomId == chatRoomId) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.messageContent, messageContent) ||
                other.messageContent == messageContent) &&
            (identical(other.messageSentAt, messageSentAt) ||
                other.messageSentAt == messageSentAt) &&
            const DeepCollectionEquality()
                .equals(other.messageContext, messageContext) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        reporterNickname,
        reportType,
        targetId,
        targetUrl,
        targetMemberId,
        targetMemberNickname,
        reportReason,
        description,
        isProcessed,
        adminNickname,
        sanctionType,
        sanctionReason,
        sanctionStartDate,
        sanctionEndDate,
        isSanctionActive,
        chatRoomId,
        messageId,
        messageContent,
        messageSentAt,
        const DeepCollectionEquality().hash(messageContext),
        createdAt
      ]);

  @override
  String toString() {
    return 'ReportAdminSanction(id: $id, reporterNickname: $reporterNickname, reportType: $reportType, targetId: $targetId, targetUrl: $targetUrl, targetMemberId: $targetMemberId, targetMemberNickname: $targetMemberNickname, reportReason: $reportReason, description: $description, isProcessed: $isProcessed, adminNickname: $adminNickname, sanctionType: $sanctionType, sanctionReason: $sanctionReason, sanctionStartDate: $sanctionStartDate, sanctionEndDate: $sanctionEndDate, isSanctionActive: $isSanctionActive, chatRoomId: $chatRoomId, messageId: $messageId, messageContent: $messageContent, messageSentAt: $messageSentAt, messageContext: $messageContext, createdAt: $createdAt)';
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
      int? targetId,
      String? targetUrl,
      int? targetMemberId,
      String? targetMemberNickname,
      String reportReason,
      String? description,
      bool isProcessed,
      String? adminNickname,
      String? sanctionType,
      String? sanctionReason,
      String? sanctionStartDate,
      String? sanctionEndDate,
      bool? isSanctionActive,
      String? chatRoomId,
      String? messageId,
      String? messageContent,
      String? messageSentAt,
      List<ReportMessageContext> messageContext,
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
    Object? targetId = freezed,
    Object? targetUrl = freezed,
    Object? targetMemberId = freezed,
    Object? targetMemberNickname = freezed,
    Object? reportReason = null,
    Object? description = freezed,
    Object? isProcessed = null,
    Object? adminNickname = freezed,
    Object? sanctionType = freezed,
    Object? sanctionReason = freezed,
    Object? sanctionStartDate = freezed,
    Object? sanctionEndDate = freezed,
    Object? isSanctionActive = freezed,
    Object? chatRoomId = freezed,
    Object? messageId = freezed,
    Object? messageContent = freezed,
    Object? messageSentAt = freezed,
    Object? messageContext = null,
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
      targetId: freezed == targetId
          ? _self.targetId
          : targetId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetUrl: freezed == targetUrl
          ? _self.targetUrl
          : targetUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
      targetMemberNickname: freezed == targetMemberNickname
          ? _self.targetMemberNickname
          : targetMemberNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      reportReason: null == reportReason
          ? _self.reportReason
          : reportReason // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isProcessed: null == isProcessed
          ? _self.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
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
      isSanctionActive: freezed == isSanctionActive
          ? _self.isSanctionActive
          : isSanctionActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      chatRoomId: freezed == chatRoomId
          ? _self.chatRoomId
          : chatRoomId // ignore: cast_nullable_to_non_nullable
              as String?,
      messageId: freezed == messageId
          ? _self.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      messageContent: freezed == messageContent
          ? _self.messageContent
          : messageContent // ignore: cast_nullable_to_non_nullable
              as String?,
      messageSentAt: freezed == messageSentAt
          ? _self.messageSentAt
          : messageSentAt // ignore: cast_nullable_to_non_nullable
              as String?,
      messageContext: null == messageContext
          ? _self.messageContext
          : messageContext // ignore: cast_nullable_to_non_nullable
              as List<ReportMessageContext>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReportAdminSanction].
extension ReportAdminSanctionPatterns on ReportAdminSanction {
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
