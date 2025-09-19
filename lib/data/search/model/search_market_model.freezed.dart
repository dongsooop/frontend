// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_market_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchMarketModel {
  int get boardId;
  String get title;
  String get content;
  DateTime get createdAt;
  int get price;
  int get contactCount;

  /// Create a copy of SearchMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchMarketModelCopyWith<SearchMarketModel> get copyWith =>
      _$SearchMarketModelCopyWithImpl<SearchMarketModel>(
          this as SearchMarketModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchMarketModel &&
            (identical(other.boardId, boardId) || other.boardId == boardId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.contactCount, contactCount) ||
                other.contactCount == contactCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, boardId, title, content, createdAt, price, contactCount);

  @override
  String toString() {
    return 'SearchMarketModel(boardId: $boardId, title: $title, content: $content, createdAt: $createdAt, price: $price, contactCount: $contactCount)';
  }
}

/// @nodoc
abstract mixin class $SearchMarketModelCopyWith<$Res> {
  factory $SearchMarketModelCopyWith(
          SearchMarketModel value, $Res Function(SearchMarketModel) _then) =
      _$SearchMarketModelCopyWithImpl;
  @useResult
  $Res call(
      {int boardId,
      String title,
      String content,
      DateTime createdAt,
      int price,
      int contactCount});
}

/// @nodoc
class _$SearchMarketModelCopyWithImpl<$Res>
    implements $SearchMarketModelCopyWith<$Res> {
  _$SearchMarketModelCopyWithImpl(this._self, this._then);

  final SearchMarketModel _self;
  final $Res Function(SearchMarketModel) _then;

  /// Create a copy of SearchMarketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boardId = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? price = null,
    Object? contactCount = null,
  }) {
    return _then(SearchMarketModel(
      boardId: null == boardId
          ? _self.boardId
          : boardId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      contactCount: null == contactCount
          ? _self.contactCount
          : contactCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
