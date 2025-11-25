// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      distance: (json['distance'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RestaurantsTagEnumMap, e))
          .toList(),
      externalMapId: json['externalMapId'] as String,
      category: json['category'] as String,
      placeUrl: json['placeUrl'] as String?,
      likedByMe: json['likedByMe'] as bool,
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'distance': instance.distance,
      'likeCount': instance.likeCount,
      'tags': instance.tags?.map((e) => _$RestaurantsTagEnumMap[e]!).toList(),
      'externalMapId': instance.externalMapId,
      'category': instance.category,
      'placeUrl': instance.placeUrl,
      'likedByMe': instance.likedByMe,
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
