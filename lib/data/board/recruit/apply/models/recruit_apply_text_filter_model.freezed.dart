// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_apply_text_filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitApplyTextFilterModel {
  String get text;

  /// Create a copy of RecruitApplyTextFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitApplyTextFilterModelCopyWith<RecruitApplyTextFilterModel>
      get copyWith => _$RecruitApplyTextFilterModelCopyWithImpl<
              RecruitApplyTextFilterModel>(
          this as RecruitApplyTextFilterModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitApplyTextFilterModel &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'RecruitApplyTextFilterModel(text: $text)';
  }
}

/// @nodoc
abstract mixin class $RecruitApplyTextFilterModelCopyWith<$Res> {
  factory $RecruitApplyTextFilterModelCopyWith(
          RecruitApplyTextFilterModel value,
          $Res Function(RecruitApplyTextFilterModel) _then) =
      _$RecruitApplyTextFilterModelCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$RecruitApplyTextFilterModelCopyWithImpl<$Res>
    implements $RecruitApplyTextFilterModelCopyWith<$Res> {
  _$RecruitApplyTextFilterModelCopyWithImpl(this._self, this._then);

  final RecruitApplyTextFilterModel _self;
  final $Res Function(RecruitApplyTextFilterModel) _then;

  /// Create a copy of RecruitApplyTextFilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(RecruitApplyTextFilterModel(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
