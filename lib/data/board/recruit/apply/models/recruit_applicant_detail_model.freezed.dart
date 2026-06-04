// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_applicant_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitApplicantDetailModel {
  int get boardId;
  String get title;
  int get applierId;
  String get applierName;
  String get departmentName;
  String get status;
  DateTime get applyTime;
  String? get introduction;
  String? get motivation;

  /// Create a copy of RecruitApplicantDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitApplicantDetailModelCopyWith<RecruitApplicantDetailModel>
      get copyWith => _$RecruitApplicantDetailModelCopyWithImpl<
              RecruitApplicantDetailModel>(
          this as RecruitApplicantDetailModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitApplicantDetailModel &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.applierId, applierId) ||
                other.applierId == applierId) &&
            (identical(other.applierName, applierName) ||
                other.applierName == applierName) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applyTime, applyTime) ||
                other.applyTime == applyTime) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            (identical(other.motivation, motivation) ||
                other.motivation == motivation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, boardId, title, applierId,
      applierName, departmentName, status, applyTime, introduction, motivation);

  @override
  String toString() {
    return 'RecruitApplicantDetailModel(boardId: $boardId, title: $title, applierId: $applierId, applierName: $applierName, departmentName: $departmentName, status: $status, applyTime: $applyTime, introduction: $introduction, motivation: $motivation)';
  }
}

/// @nodoc
abstract mixin class $RecruitApplicantDetailModelCopyWith<$Res> {
  factory $RecruitApplicantDetailModelCopyWith(
          RecruitApplicantDetailModel value,
          $Res Function(RecruitApplicantDetailModel) _then) =
      _$RecruitApplicantDetailModelCopyWithImpl;
  @useResult
  $Res call(
      {int boardId,
      String title,
      int applierId,
      String applierName,
      String departmentName,
      String status,
      DateTime applyTime,
      String? introduction,
      String? motivation});
}

/// @nodoc
class _$RecruitApplicantDetailModelCopyWithImpl<$Res>
    implements $RecruitApplicantDetailModelCopyWith<$Res> {
  _$RecruitApplicantDetailModelCopyWithImpl(this._self, this._then);

  final RecruitApplicantDetailModel _self;
  final $Res Function(RecruitApplicantDetailModel) _then;

  /// Create a copy of RecruitApplicantDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? title = null,
    Object? applierId = null,
    Object? applierName = null,
    Object? departmentName = null,
    Object? status = null,
    Object? applyTime = null,
    Object? introduction = freezed,
    Object? motivation = freezed,
  }) {
    return _then(RecruitApplicantDetailModel(
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      applierId: null == applierId
          ? _self.applierId
          : applierId // ignore: cast_nullable_to_non_nullable
              as int,
      applierName: null == applierName
          ? _self.applierName
          : applierName // ignore: cast_nullable_to_non_nullable
              as String,
      departmentName: null == departmentName
          ? _self.departmentName
          : departmentName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      applyTime: null == applyTime
          ? _self.applyTime
          : applyTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      introduction: freezed == introduction
          ? _self.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String?,
      motivation: freezed == motivation
          ? _self.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecruitApplicantDetailModel].
extension RecruitApplicantDetailModelPatterns on RecruitApplicantDetailModel {
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
