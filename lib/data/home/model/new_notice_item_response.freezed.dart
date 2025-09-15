// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_notice_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewNoticeItemResponse {
  String get title;
  String get link;
  String get type;

  /// Create a copy of NewNoticeItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewNoticeItemResponseCopyWith<NewNoticeItemResponse> get copyWith =>
      _$NewNoticeItemResponseCopyWithImpl<NewNoticeItemResponse>(
          this as NewNoticeItemResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewNoticeItemResponse &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, link, type);

  @override
  String toString() {
    return 'NewNoticeItemResponse(title: $title, link: $link, type: $type)';
  }
}

/// @nodoc
abstract mixin class $NewNoticeItemResponseCopyWith<$Res> {
  factory $NewNoticeItemResponseCopyWith(NewNoticeItemResponse value,
          $Res Function(NewNoticeItemResponse) _then) =
      _$NewNoticeItemResponseCopyWithImpl;
  @useResult
  $Res call({String title, String link, String type});
}

/// @nodoc
class _$NewNoticeItemResponseCopyWithImpl<$Res>
    implements $NewNoticeItemResponseCopyWith<$Res> {
  _$NewNoticeItemResponseCopyWithImpl(this._self, this._then);

  final NewNoticeItemResponse _self;
  final $Res Function(NewNoticeItemResponse) _then;

  /// Create a copy of NewNoticeItemResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? link = null,
    Object? type = null,
  }) {
    return _then(NewNoticeItemResponse(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
