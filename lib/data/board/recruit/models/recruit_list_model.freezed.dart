// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recruit_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecruitListModel {
  int get id;
  int get volunteer;
  DateTime get startAt;
  DateTime get endAt;
  String get title;
  String get content;
  String get tags;

  /// Create a copy of RecruitListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecruitListModelCopyWith<RecruitListModel> get copyWith =>
      _$RecruitListModelCopyWithImpl<RecruitListModel>(
          this as RecruitListModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecruitListModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.volunteer, volunteer) ||
                other.volunteer == volunteer) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tags, tags) || other.tags == tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, volunteer, startAt, endAt, title, content, tags);

  @override
  String toString() {
    return 'RecruitListModel(id: $id, volunteer: $volunteer, startAt: $startAt, endAt: $endAt, title: $title, content: $content, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $RecruitListModelCopyWith<$Res> {
  factory $RecruitListModelCopyWith(
          RecruitListModel value, $Res Function(RecruitListModel) _then) =
      _$RecruitListModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      int volunteer,
      DateTime startAt,
      DateTime endAt,
      String title,
      String content,
      String tags});
}

/// @nodoc
class _$RecruitListModelCopyWithImpl<$Res>
    implements $RecruitListModelCopyWith<$Res> {
  _$RecruitListModelCopyWithImpl(this._self, this._then);

  final RecruitListModel _self;
  final $Res Function(RecruitListModel) _then;

  /// Create a copy of RecruitListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? volunteer = null,
    Object? startAt = null,
    Object? endAt = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
  }) {
    return _then(RecruitListModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      volunteer: null == volunteer
          ? _self.volunteer
          : volunteer // ignore: cast_nullable_to_non_nullable
              as int,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endAt: null == endAt
          ? _self.endAt
          : endAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
    ));
  }
}

// dart format on
