// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketListModel _$MarketListModelFromJson(Map<String, dynamic> json) =>
    MarketListModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      price: (json['price'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      contactCount: (json['contactCount'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$MarketListModelToJson(MarketListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'contactCount': instance.contactCount,
      'imageUrl': instance.imageUrl,
    };
