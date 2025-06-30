// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_write_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketWriteModel _$MarketWriteModelFromJson(Map<String, dynamic> json) =>
    MarketWriteModel(
      title: json['title'] as String,
      content: json['content'] as String,
      price: (json['price'] as num).toInt(),
      type: json['type'] as String,
      deleteImageUrls: (json['deleteImageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MarketWriteModelToJson(MarketWriteModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'price': instance.price,
      'type': instance.type,
      'deleteImageUrls': instance.deleteImageUrls,
    };
