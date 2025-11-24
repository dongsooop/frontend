import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurants_request.freezed.dart';
part 'restaurants_request.g.dart';

@freezed
@JsonSerializable()
class RestaurantsRequest with _$RestaurantsRequest {
  final String externalMapId;
  final String name;
  final String placeUrl;
  final String distance;
  final RestaurantsCategory category;
  final List<String>? tags;

  const RestaurantsRequest({
    required this.externalMapId,
    required this.name,
    required this.placeUrl,
    required this.distance,
    required this.category,
    this.tags,
  });

  Map<String, dynamic> toJson() => _$RestaurantsRequestToJson(this);
  factory RestaurantsRequest.fromJson(Map<String, dynamic> json) => _$RestaurantsRequestFromJson(json);
}