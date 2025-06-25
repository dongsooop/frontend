// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketDetailModel {
  int get id;
  String get title;
  String get content;
  int get price;
  DateTime get createdAt;
  int get contactCount;
  List<String> get imageUrlList;
  String get viewType;

  /// Create a copy of MarketDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarketDetailModelCopyWith<MarketDetailModel> get copyWith =>
      _$MarketDetailModelCopyWithImpl<MarketDetailModel>(
          this as MarketDetailModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarketDetailModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.contactCount, contactCount) ||
                other.contactCount == contactCount) &&
            const DeepCollectionEquality()
                .equals(other.imageUrlList, imageUrlList) &&
            (identical(other.viewType, viewType) ||
                other.viewType == viewType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      price,
      createdAt,
      contactCount,
      const DeepCollectionEquality().hash(imageUrlList),
      viewType);

  @override
  String toString() {
    return 'MarketDetailModel(id: $id, title: $title, content: $content, price: $price, createdAt: $createdAt, contactCount: $contactCount, imageUrlList: $imageUrlList, viewType: $viewType)';
  }
}

/// @nodoc
abstract mixin class $MarketDetailModelCopyWith<$Res> {
  factory $MarketDetailModelCopyWith(
          MarketDetailModel value, $Res Function(MarketDetailModel) _then) =
      _$MarketDetailModelCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String title,
      String content,
      int price,
      DateTime createdAt,
      int contactCount,
      List<String> imageUrlList,
      String viewType});
}

/// @nodoc
class _$MarketDetailModelCopyWithImpl<$Res>
    implements $MarketDetailModelCopyWith<$Res> {
  _$MarketDetailModelCopyWithImpl(this._self, this._then);

  final MarketDetailModel _self;
  final $Res Function(MarketDetailModel) _then;

  /// Create a copy of MarketDetailModel
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
    Object? imageUrlList = null,
    Object? viewType = null,
  }) {
    return _then(MarketDetailModel(
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
      imageUrlList: null == imageUrlList
          ? _self.imageUrlList
          : imageUrlList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      viewType: null == viewType
          ? _self.viewType
          : viewType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
