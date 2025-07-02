// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketDetailModel _$MarketDetailModelFromJson(Map<String, dynamic> json) =>
    MarketDetailModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      price: (json['price'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as String,
      contactCount: (json['contactCount'] as num).toInt(),
      imageUrlList: (json['imageUrlList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      viewType: json['viewType'] as String,
    );

Map<String, dynamic> _$MarketDetailModelToJson(MarketDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.type,
      'contactCount': instance.contactCount,
      'imageUrlList': instance.imageUrlList,
      'viewType': instance.viewType,
    };
