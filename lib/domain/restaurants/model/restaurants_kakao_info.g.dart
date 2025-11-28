// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurants_kakao_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantsKakaoInfo _$RestaurantsKakaoInfoFromJson(
        Map<String, dynamic> json) =>
    RestaurantsKakaoInfo(
      id: json['id'] as String,
      place_name: json['place_name'] as String,
      road_address_name: json['road_address_name'] as String,
      place_url: json['place_url'] as String,
      distance: json['distance'] as String,
    );

Map<String, dynamic> _$RestaurantsKakaoInfoToJson(
        RestaurantsKakaoInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'place_name': instance.place_name,
      'road_address_name': instance.road_address_name,
      'place_url': instance.place_url,
      'distance': instance.distance,
    };
