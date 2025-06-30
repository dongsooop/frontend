// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_write_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketWriteModel {
  String get title;
  String get content;
  int get price;
  String get type;
  List<String>? get deleteImageUrls;

  /// Create a copy of MarketWriteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarketWriteModelCopyWith<MarketWriteModel> get copyWith =>
      _$MarketWriteModelCopyWithImpl<MarketWriteModel>(
          this as MarketWriteModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarketWriteModel &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.deleteImageUrls, deleteImageUrls));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, content, price, type,
      const DeepCollectionEquality().hash(deleteImageUrls));

  @override
  String toString() {
    return 'MarketWriteModel(title: $title, content: $content, price: $price, type: $type, deleteImageUrls: $deleteImageUrls)';
  }
}

/// @nodoc
abstract mixin class $MarketWriteModelCopyWith<$Res> {
  factory $MarketWriteModelCopyWith(
          MarketWriteModel value, $Res Function(MarketWriteModel) _then) =
      _$MarketWriteModelCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String content,
      int price,
      String type,
      List<String>? deleteImageUrls});
}

/// @nodoc
class _$MarketWriteModelCopyWithImpl<$Res>
    implements $MarketWriteModelCopyWith<$Res> {
  _$MarketWriteModelCopyWithImpl(this._self, this._then);

  final MarketWriteModel _self;
  final $Res Function(MarketWriteModel) _then;

  /// Create a copy of MarketWriteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? content = null,
    Object? price = null,
    Object? type = null,
    Object? deleteImageUrls = freezed,
  }) {
    return _then(MarketWriteModel(
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
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      deleteImageUrls: freezed == deleteImageUrls
          ? _self.deleteImageUrls
          : deleteImageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

// dart format on
