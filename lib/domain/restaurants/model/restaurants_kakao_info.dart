import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurants_kakao_info.freezed.dart';
part 'restaurants_kakao_info.g.dart';

@freezed
@JsonSerializable()
class RestaurantsKakaoInfo with _$RestaurantsKakaoInfo {
  final String id;
  final String place_name;
  final String road_address_name;
  final String place_url;
  final String distance;

  const RestaurantsKakaoInfo({
    required this.id,
    required this.place_name,
    required this.road_address_name,
    required this.place_url,
    required this.distance,
  });

  Map<String, dynamic> toJson() => _$RestaurantsKakaoInfoToJson(this);
  factory RestaurantsKakaoInfo.fromJson(Map<String, dynamic> json) => _$RestaurantsKakaoInfoFromJson(json);
}