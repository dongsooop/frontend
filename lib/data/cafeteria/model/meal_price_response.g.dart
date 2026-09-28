// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_price_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealPriceResponse _$MealPriceResponseFromJson(Map<String, dynamic> json) =>
    MealPriceResponse(
      ticketPrice: (json['ticketPrice'] as num).toInt(),
      categories: (json['categories'] as List<dynamic>)
          .map(
              (e) => MealPriceCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealPriceResponseToJson(MealPriceResponse instance) =>
    <String, dynamic>{
      'ticketPrice': instance.ticketPrice,
      'categories': instance.categories,
    };

MealPriceCategoryModel _$MealPriceCategoryModelFromJson(
        Map<String, dynamic> json) =>
    MealPriceCategoryModel(
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MealPriceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$MealPriceCategoryModelToJson(
        MealPriceCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'note': instance.note,
      'items': instance.items,
    };

MealPriceItemModel _$MealPriceItemModelFromJson(Map<String, dynamic> json) =>
    MealPriceItemModel(
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      largePrice: (json['largePrice'] as num?)?.toInt(),
      days: (json['days'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MealPriceItemModelToJson(MealPriceItemModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'largePrice': instance.largePrice,
      'days': instance.days,
    };
