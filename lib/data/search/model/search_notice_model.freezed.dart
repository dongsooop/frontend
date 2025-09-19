// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_notice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchNoticeModel {
  int get boardId;
  String get title;
  String get authorName;
  DateTime get createdAt;
  String get noticeUrl;

  /// Create a copy of SearchNoticeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchNoticeModelCopyWith<SearchNoticeModel> get copyWith =>
      _$SearchNoticeModelCopyWithImpl<SearchNoticeModel>(
          this as SearchNoticeModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchNoticeModel &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.noticeUrl, noticeUrl) ||
                other.noticeUrl == noticeUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, boardId, title, authorName, createdAt, noticeUrl);

  @override
  String toString() {
    return 'SearchNoticeModel(boardId: $boardId, title: $title, authorName: $authorName, createdAt: $createdAt, noticeUrl: $noticeUrl)';
  }
}

/// @nodoc
abstract mixin class $SearchNoticeModelCopyWith<$Res> {
  factory $SearchNoticeModelCopyWith(
          SearchNoticeModel value, $Res Function(SearchNoticeModel) _then) =
      _$SearchNoticeModelCopyWithImpl;
  @useResult
  $Res call(
      {int boardId,
      String title,
      String authorName,
      DateTime createdAt,
      String noticeUrl});
}

/// @nodoc
class _$SearchNoticeModelCopyWithImpl<$Res>
    implements $SearchNoticeModelCopyWith<$Res> {
  _$SearchNoticeModelCopyWithImpl(this._self, this._then);

  final SearchNoticeModel _self;
  final $Res Function(SearchNoticeModel) _then;

  /// Create a copy of SearchNoticeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? title = null,
    Object? authorName = null,
    Object? createdAt = null,
    Object? noticeUrl = null,
  }) {
    return _then(SearchNoticeModel(
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      noticeUrl: null == noticeUrl
          ? _self.noticeUrl
          : noticeUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on