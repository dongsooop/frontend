// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketListModel {
  int get id;
  String get title;
  String get content;
  int get price;
  DateTime get createdAt;
  int get contactCount;
  String? get imageUrl;

  /// Create a copy of MarketListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarketListModelCopyWith<MarketListModel> get copyWith =>
      _$MarketListModelCopyWithImpl<MarketListModel>(
          this as MarketListModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarketListModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.contactCount, contactCount) ||
                other.contactCount == contactCount) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, content, price,
      createdAt, contactCount, imageUrl);

  @override
  String toString() {
    return 'MarketListModel(id: $id, title: $title, content: $content, price: $price, createdAt: $createdAt, contactCount: $contactCount, imageUrl: $imageUrl)';
  }
}

/// @nodoc
abstract mixin class $MarketListModelCopyWith<$Res> {
  factory $MarketListModelCopyWith(
          MarketListModel value, $Res Function(MarketListModel) _then) =
      _$MarketListModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      int price,
      DateTime createdAt,
      int contactCount,
      String? imageUrl});
}

/// @nodoc
class _$MarketListModelCopyWithImpl<$Res>
    implements $MarketListModelCopyWith<$Res> {
  _$MarketListModelCopyWithImpl(this._self, this._then);

  final MarketListModel _self;
  final $Res Function(MarketListModel) _then;

  /// Create a copy of MarketListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? price = null,
    Object? createdAt = null,
    Object? contactCount = null,
    Object? imageUrl = freezed,
  }) {
    return _then(MarketListModel(
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
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      contactCount: null == contactCount
          ? _self.contactCount
          : contactCount // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
