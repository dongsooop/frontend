// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_apply_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitApplyModel {
  int get boardId;
  String? get introduction;
  String? get motivation;

  /// Create a copy of RecruitApplyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitApplyModelCopyWith<RecruitApplyModel> get copyWith =>
      _$RecruitApplyModelCopyWithImpl<RecruitApplyModel>(
          this as RecruitApplyModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitApplyModel &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            (identical(other.motivation, motivation) ||
                other.motivation == motivation));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, boardId, introduction, motivation);

  @override
  String toString() {
    return 'RecruitApplyModel(boardId: $boardId, introduction: $introduction, motivation: $motivation)';
  }
}

/// @nodoc
abstract mixin class $RecruitApplyModelCopyWith<$Res> {
  factory $RecruitApplyModelCopyWith(
          RecruitApplyModel value, $Res Function(RecruitApplyModel) _then) =
      _$RecruitApplyModelCopyWithImpl;
  @useResult
  $Res call({int boardId, String? introduction, String? motivation});
}

/// @nodoc
class _$RecruitApplyModelCopyWithImpl<$Res>
    implements $RecruitApplyModelCopyWith<$Res> {
  _$RecruitApplyModelCopyWithImpl(this._self, this._then);

  final RecruitApplyModel _self;
  final $Res Function(RecruitApplyModel) _then;

  /// Create a copy of RecruitApplyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? introduction = freezed,
    Object? motivation = freezed,
  }) {
    return _then(RecruitApplyModel(
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
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

// dart format on
