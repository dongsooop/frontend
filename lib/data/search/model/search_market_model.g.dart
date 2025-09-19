// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_market_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMarketModel _$SearchMarketModelFromJson(Map<String, dynamic> json) =>
    SearchMarketModel(
      boardId: (json['boardId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      price: (json['price'] as num).toInt(),
      contactCount: (json['contactCount'] as num).toInt(),
    );

Map<String, dynamic> _$SearchMarketModelToJson(SearchMarketModel instance) =>
    <String, dynamic>{
      'boardId': instance.boardId,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'price': instance.price,
      'contactCount': instance.contactCount,
    };
