// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_decision_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitDecisionModel {
  String get status;
  int get applierId;

  /// Create a copy of RecruitDecisionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitDecisionModelCopyWith<RecruitDecisionModel> get copyWith =>
      _$RecruitDecisionModelCopyWithImpl<RecruitDecisionModel>(
          this as RecruitDecisionModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitDecisionModel &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applierId, applierId) ||
                other.applierId == applierId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, applierId);

  @override
  String toString() {
    return 'RecruitDecisionModel(status: $status, applierId: $applierId)';
  }
}

/// @nodoc
abstract mixin class $RecruitDecisionModelCopyWith<$Res> {
  factory $RecruitDecisionModelCopyWith(RecruitDecisionModel value,
          $Res Function(RecruitDecisionModel) _then) =
      _$RecruitDecisionModelCopyWithImpl;
  @useResult
  $Res call({String status, int applierId});
}

/// @nodoc
class _$RecruitDecisionModelCopyWithImpl<$Res>
    implements $RecruitDecisionModelCopyWith<$Res> {
  _$RecruitDecisionModelCopyWithImpl(this._self, this._then);

  final RecruitDecisionModel _self;
  final $Res Function(RecruitDecisionModel) _then;

  /// Create a copy of RecruitDecisionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? applierId = null,
  }) {
    return _then(RecruitDecisionModel(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      applierId: null == applierId
          ? _self.applierId
          : applierId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
