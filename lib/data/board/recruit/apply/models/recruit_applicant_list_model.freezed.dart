// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_applicant_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitApplicantListModel {
  String get memberName;
  int get memberId;
  String get departmentName;
  String get status;

  /// Create a copy of RecruitApplicantListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitApplicantListModelCopyWith<RecruitApplicantListModel> get copyWith =>
      _$RecruitApplicantListModelCopyWithImpl<RecruitApplicantListModel>(
          this as RecruitApplicantListModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitApplicantListModel &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberName, memberId, departmentName, status);

  @override
  String toString() {
    return 'RecruitApplicantListModel(memberName: $memberName, memberId: $memberId, departmentName: $departmentName, status: $status)';
  }
}

/// @nodoc
abstract mixin class $RecruitApplicantListModelCopyWith<$Res> {
  factory $RecruitApplicantListModelCopyWith(RecruitApplicantListModel value,
          $Res Function(RecruitApplicantListModel) _then) =
      _$RecruitApplicantListModelCopyWithImpl;
  @useResult
  $Res call(
      {String memberName, int memberId, String departmentName, String status});
}

/// @nodoc
class _$RecruitApplicantListModelCopyWithImpl<$Res>
    implements $RecruitApplicantListModelCopyWith<$Res> {
  _$RecruitApplicantListModelCopyWithImpl(this._self, this._then);

  final RecruitApplicantListModel _self;
  final $Res Function(RecruitApplicantListModel) _then;

  /// Create a copy of RecruitApplicantListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberName = null,
    Object? memberId = null,
    Object? departmentName = null,
    Object? status = null,
  }) {
    return _then(RecruitApplicantListModel(
      memberName: null == memberName
          ? _self.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      departmentName: null == departmentName
          ? _self.departmentName
          : departmentName // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
