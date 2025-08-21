// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_write_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitWriteModel {
  String get title;
  String get content;
  String get tags;
  DateTime get startAt;
  DateTime get endAt;
  List<String> get departmentTypeList;

  /// Create a copy of RecruitWriteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitWriteModelCopyWith<RecruitWriteModel> get copyWith =>
      _$RecruitWriteModelCopyWithImpl<RecruitWriteModel>(
          this as RecruitWriteModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitWriteModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            const DeepCollectionEquality()
                .equals(other.departmentTypeList, departmentTypeList));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, content, tags, startAt,
      endAt, const DeepCollectionEquality().hash(departmentTypeList));

  @override
  String toString() {
    return 'RecruitWriteModel(title: $title, content: $content, tags: $tags, startAt: $startAt, endAt: $endAt, departmentTypeList: $departmentTypeList)';
  }
}

/// @nodoc
abstract mixin class $RecruitWriteModelCopyWith<$Res> {
  factory $RecruitWriteModelCopyWith(
          RecruitWriteModel value, $Res Function(RecruitWriteModel) _then) =
      _$RecruitWriteModelCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String content,
      String tags,
      DateTime startAt,
      DateTime endAt,
      List<String> departmentTypeList});
}

/// @nodoc
class _$RecruitWriteModelCopyWithImpl<$Res>
    implements $RecruitWriteModelCopyWith<$Res> {
  _$RecruitWriteModelCopyWithImpl(this._self, this._then);

  final RecruitWriteModel _self;
  final $Res Function(RecruitWriteModel) _then;

  /// Create a copy of RecruitWriteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? departmentTypeList = null,
  }) {
    return _then(RecruitWriteModel(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      departmentTypeList: null == departmentTypeList
          ? _self.departmentTypeList
          : departmentTypeList // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
