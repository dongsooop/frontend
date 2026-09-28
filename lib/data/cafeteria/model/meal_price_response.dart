import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_price_response.g.dart';

@JsonSerializable()
class MealPriceResponse {
  final int ticketPrice;
  final List<MealPriceCategoryModel> categories;

  MealPriceResponse({
    required this.ticketPrice,
    required this.categories,
  });

  factory MealPriceResponse.fromJson(Map<String, dynamic> json) =>
      _$MealPriceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealPriceResponseToJson(this);
}

@JsonSerializable()
class MealPriceCategoryModel {
  final String name;
  final String? note;
  final List<MealPriceItemModel> items;

  MealPriceCategoryModel({
    required this.name,
    required this.items,
    this.note,
  });

  factory MealPriceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$MealPriceCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealPriceCategoryModelToJson(this);
}

@JsonSerializable()
class MealPriceItemModel {
  final String name;
  final int price;
  final int? largePrice;

  /// 서버는 매일 파는 메뉴에 이 키를 아예 넣지 않는다.
  final List<String>? days;

  MealPriceItemModel({
    required this.name,
    required this.price,
    this.largePrice,
    this.days,
  });

  factory MealPriceItemModel.fromJson(Map<String, dynamic> json) =>
      _$MealPriceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealPriceItemModelToJson(this);
}

extension MealPriceMapper on MealPriceResponse {
  MealPriceEntity toEntity() {
    return MealPriceEntity(
      ticketPrice: ticketPrice,
      categories: categories.map((e) => e.toEntity()).toList(),
    );
  }
}

extension MealPriceCategoryMapper on MealPriceCategoryModel {
  MealPriceCategoryEntity toEntity() {
    return MealPriceCategoryEntity(
      name: name,
      note: note,
      items: items.map((e) => e.toEntity()).toList(),
    );
  }
}

extension MealPriceItemMapper on MealPriceItemModel {
  MealPriceItemEntity toEntity() {
    return MealPriceItemEntity(
      name: name,
      price: price,
      largePrice: largePrice,
      days: days ?? const [],
    );
  }
}
