import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:flutter/material.dart';

/// 맛집 카테고리별 색과 이모지.
///
/// 카카오 로컬 API 에 이미지 필드가 없어 가게 사진을 받을 수 없다.
/// 카테고리로 색 면을 깔아 사진 자리를 대신한다.
/// 분류가 없거나 서버에 새 카테고리가 생기면 밥 모양으로 떨어진다.
class RestaurantCategoryStyle {
  final String emoji;
  final Color background;

  const RestaurantCategoryStyle(this.emoji, this.background);

  static const fallback = RestaurantCategoryStyle('🍚', Color(0xFFF2F4F6));

  static const _byCategory = <RestaurantsCategory, RestaurantCategoryStyle>{
    RestaurantsCategory.KOREAN:
        RestaurantCategoryStyle('🍚', Color(0xFFFFF1E0)),
    RestaurantsCategory.CHINESE:
        RestaurantCategoryStyle('🥟', Color(0xFFFCE9E7)),
    RestaurantsCategory.JAPANESE:
        RestaurantCategoryStyle('🍣', Color(0xFFE7F3FC)),
    RestaurantsCategory.WESTERN:
        RestaurantCategoryStyle('🍝', Color(0xFFF1EDFB)),
    RestaurantsCategory.BUNSIK:
        RestaurantCategoryStyle('🍢', Color(0xFFFDECF2)),
    RestaurantsCategory.FAST_FOOD:
        RestaurantCategoryStyle('🍔', Color(0xFFFFF6DE)),
    RestaurantsCategory.CAFE_DESSERT:
        RestaurantCategoryStyle('☕', Color(0xFFEFEAE4)),
  };

  /// 서버가 내려주는 카테고리 문자열을 enum 이름과 맞춰본다.
  /// 표시용 한글 이름으로 올 수도 있어 둘 다 확인한다.
  static RestaurantCategoryStyle of(String? rawCategory) {
    if (rawCategory == null || rawCategory.isEmpty) return fallback;

    for (final entry in _byCategory.entries) {
      if (entry.key.name == rawCategory || entry.key.label == rawCategory) {
        return entry.value;
      }
    }
    return fallback;
  }
}
