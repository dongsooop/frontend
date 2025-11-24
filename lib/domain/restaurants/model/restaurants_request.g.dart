// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurants_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantsRequest _$RestaurantsRequestFromJson(Map<String, dynamic> json) =>
    RestaurantsRequest(
      externalMapId: json['externalMapId'] as String,
      name: json['name'] as String,
      placeUrl: json['placeUrl'] as String,
      distance: json['distance'] as String,
      category: $enumDecode(_$RestaurantsCategoryEnumMap, json['category']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RestaurantsRequestToJson(RestaurantsRequest instance) =>
    <String, dynamic>{
      'externalMapId': instance.externalMapId,
      'name': instance.name,
      'placeUrl': instance.placeUrl,
      'distance': instance.distance,
      'category': _$RestaurantsCategoryEnumMap[instance.category]!,
      'tags': instance.tags,
    };

const _$RestaurantsCategoryEnumMap = {
  RestaurantsCategory.KOREAN: 'KOREAN',
  RestaurantsCategory.CHINESE: 'CHINESE',
  RestaurantsCategory.JAPANESE: 'JAPANESE',
  RestaurantsCategory.WESTERN: 'WESTERN',
  RestaurantsCategory.BUNSIK: 'BUNSIK',
  RestaurantsCategory.FAST_FOOD: 'FAST_FOOD',
  RestaurantsCategory.CAFE_DESSERT: 'CAFE_DESSERT',
};
