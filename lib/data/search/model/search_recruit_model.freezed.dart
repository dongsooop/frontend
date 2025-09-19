// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_recruit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchRecruitModel {
  int get boardId;
  String get title;
  String? get content;
  RecruitType get boardType;
  DateTime get createdAt;
  int get contactCount;
  DateTime? get recruitmentStartAt;
  DateTime? get recruitmentEndAt;
  String get tags;
  String get departmentName;

  /// Create a copy of SearchRecruitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchRecruitModelCopyWith<SearchRecruitModel> get copyWith =>
      _$SearchRecruitModelCopyWithImpl<SearchRecruitModel>(
          this as SearchRecruitModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchRecruitModel &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.boardType, boardType) ||
                other.boardType == boardType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.contactCount, contactCount) ||
                other.contactCount == contactCount) &&
            (identical(other.recruitmentStartAt, recruitmentStartAt) ||
                other.recruitmentStartAt == recruitmentStartAt) &&
            (identical(other.recruitmentEndAt, recruitmentEndAt) ||
                other.recruitmentEndAt == recruitmentEndAt) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            (identical(other.departmentName, departmentName) ||
                other.departmentName == departmentName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      boardId,
      title,
      content,
      boardType,
      createdAt,
      contactCount,
      recruitmentStartAt,
      recruitmentEndAt,
      tags,
      departmentName);

  @override
  String toString() {
    return 'SearchRecruitModel(boardId: $boardId, title: $title, content: $content, boardType: $boardType, createdAt: $createdAt, contactCount: $contactCount, recruitmentStartAt: $recruitmentStartAt, recruitmentEndAt: $recruitmentEndAt, tags: $tags, departmentName: $departmentName)';
  }
}

/// @nodoc
abstract mixin class $SearchRecruitModelCopyWith<$Res> {
  factory $SearchRecruitModelCopyWith(
          SearchRecruitModel value, $Res Function(SearchRecruitModel) _then) =
      _$SearchRecruitModelCopyWithImpl;
  @useResult
  $Res call(
      {int boardId,
      String title,
      String? content,
      RecruitType boardType,
      DateTime createdAt,
      int contactCount,
      DateTime? recruitmentStartAt,
      DateTime? recruitmentEndAt,
      String tags,
      String departmentName});
}

/// @nodoc
class _$SearchRecruitModelCopyWithImpl<$Res>
    implements $SearchRecruitModelCopyWith<$Res> {
  _$SearchRecruitModelCopyWithImpl(this._self, this._then);

  final SearchRecruitModel _self;
  final $Res Function(SearchRecruitModel) _then;

  /// Create a copy of SearchRecruitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? title = null,
    Object? content = freezed,
    Object? boardType = null,
    Object? createdAt = null,
    Object? contactCount = null,
    Object? recruitmentStartAt = freezed,
    Object? recruitmentEndAt = freezed,
    Object? tags = null,
    Object? departmentName = null,
  }) {
    return _then(SearchRecruitModel(
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      boardType: null == boardType
          ? _self.boardType
          : boardType // ignore: cast_nullable_to_non_nullable
              as RecruitType,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contactCount: null == contactCount
          ? _self.contactCount
          : contactCount // ignore: cast_nullable_to_non_nullable
              as int,
      recruitmentStartAt: freezed == recruitmentStartAt
          ? _self.recruitmentStartAt
          : recruitmentStartAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      recruitmentEndAt: freezed == recruitmentEndAt
          ? _self.recruitmentEndAt
          : recruitmentEndAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as String,
      departmentName: null == departmentName
          ? _self.departmentName
          : departmentName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
