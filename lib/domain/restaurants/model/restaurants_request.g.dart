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
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RestaurantsTagEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$RestaurantsRequestToJson(RestaurantsRequest instance) =>
    <String, dynamic>{
      'externalMapId': instance.externalMapId,
      'name': instance.name,
      'placeUrl': instance.placeUrl,
      'distance': instance.distance,
      'category': _$RestaurantsCategoryEnumMap[instance.category]!,
      'tags': instance.tags?.map((e) => _$RestaurantsTagEnumMap[e]!).toList(),
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

const _$RestaurantsTagEnumMap = {
  RestaurantsTag.LARGE_PORTION: 'LARGE_PORTION',
  RestaurantsTag.DELICIOUS: 'DELICIOUS',
  RestaurantsTag.GOOD_FOR_LUNCH: 'GOOD_FOR_LUNCH',
  RestaurantsTag.GOOD_FOR_SOLO: 'GOOD_FOR_SOLO',
  RestaurantsTag.GOOD_VALUE: 'GOOD_VALUE',
  RestaurantsTag.GOOD_FOR_GATHERING: 'GOOD_FOR_GATHERING',
  RestaurantsTag.GOOD_FOR_CONVERSATION: 'GOOD_FOR_CONVERSATION',
  RestaurantsTag.VARIOUS_MENU: 'VARIOUS_MENU',
};
