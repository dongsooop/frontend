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
  String get title;
  String get content;
  String get tags;

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
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.tags, tags) || other.tags == tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, tags);

  @override
  String toString() {
    return 'PopularRecruitItemResponse(title: $title, content: $content, tags: $tags)';
  }
}

/// @nodoc
abstract mixin class $PopularRecruitItemResponseCopyWith<$Res> {
  factory $PopularRecruitItemResponseCopyWith(PopularRecruitItemResponse value,
          $Res Function(PopularRecruitItemResponse) _then) =
      _$PopularRecruitItemResponseCopyWithImpl;
  @useResult
  $Res call({String title, String content, String tags});
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
    Object? title = null,
    Object? content = null,
    Object? tags = null,
  }) {
    return _then(PopularRecruitItemResponse(
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
