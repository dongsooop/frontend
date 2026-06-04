import 'package:dongsoop/domain/restaurants/enum/restaurants_tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

@freezed
@JsonSerializable()
class Restaurant with _$Restaurant {
  final int id;
  final String name;
  final int distance;
  final int likeCount;
  final List<RestaurantsTag>? tags;
  final String category;
  final String? placeUrl;
  final bool isLikedByMe;

  const Restaurant({
    required this.id,
    required this.name,
    required this.distance,
    required this.likeCount,
    required this.tags,
    required this.category,
    this.placeUrl,
    required this.isLikedByMe,
  });

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);
}