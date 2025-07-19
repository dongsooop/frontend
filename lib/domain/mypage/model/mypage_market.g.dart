// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mypage_market.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MypageMarket _$MypageMarketFromJson(Map<String, dynamic> json) => MypageMarket(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      price: (json['price'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      contactCount: (json['contactCount'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
      type: $enumDecode(_$MarketTypeEnumMap, json['type']),
      status: json['status'] as String,
    );

Map<String, dynamic> _$MypageMarketToJson(MypageMarket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'contactCount': instance.contactCount,
      'imageUrl': instance.imageUrl,
      'type': _$MarketTypeEnumMap[instance.type]!,
      'status': instance.status,
    };

const _$MarketTypeEnumMap = {
  MarketType.SELL: 'SELL',
  MarketType.BUY: 'BUY',
  MarketType.REPORT: 'REPORT',
};
