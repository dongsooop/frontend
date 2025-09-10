// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'popular_recruit_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PopularRecruitItemResponse {
  int get id;
  String get title;
  String get content;
  String get tags;
  int get volunteer;
  String get type;

  /// Create a copy of PopularRecruitItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PopularRecruitItemResponseCopyWith<PopularRecruitItemResponse>
      get copyWith =>
          _$PopularRecruitItemResponseCopyWithImpl<PopularRecruitItemResponse>(
              this as PopularRecruitItemResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PopularRecruitItemResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tags, tags) || other.tags == tags) &&
            (identical(other.volunteer, volunteer) ||
                other.volunteer == volunteer) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, content, tags, volunteer, type);

  @override
  String toString() {
    return 'PopularRecruitItemResponse(id: $id, title: $title, content: $content, tags: $tags, volunteer: $volunteer, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PopularRecruitItemResponseCopyWith<$Res> {
  factory $PopularRecruitItemResponseCopyWith(PopularRecruitItemResponse value,
          $Res Function(PopularRecruitItemResponse) _then) =
      _$PopularRecruitItemResponseCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      String tags,
      int volunteer,
      String type});
}

/// @nodoc
class _$PopularRecruitItemResponseCopyWithImpl<$Res>
    implements $PopularRecruitItemResponseCopyWith<$Res> {
  _$PopularRecruitItemResponseCopyWithImpl(this._self, this._then);

  final PopularRecruitItemResponse _self;
  final $Res Function(PopularRecruitItemResponse) _then;

  /// Create a copy of PopularRecruitItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? tags = null,
    Object? volunteer = null,
    Object? type = null,
  }) {
    return _then(PopularRecruitItemResponse(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      volunteer: null == volunteer
          ? _self.volunteer
          : volunteer // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
