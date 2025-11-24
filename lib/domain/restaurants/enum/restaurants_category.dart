enum RestaurantsCategory {
  KOREAN,
  CHINESE,
  JAPANESE,
  WESTERN,
  BUNSIK,
  FAST_FOOD,
  CAFE_DESSERT,
}

extension RestaurantCategoryLabel on RestaurantsCategory {
  String get label {
    switch (this) {
      case RestaurantsCategory.KOREAN:
        return '한식';
      case RestaurantsCategory.CHINESE:
        return '중식';
      case RestaurantsCategory.JAPANESE:
        return '일식';
      case RestaurantsCategory.WESTERN:
        return '양식';
      case RestaurantsCategory.BUNSIK:
        return '분식';
      case RestaurantsCategory.FAST_FOOD:
        return '패스트푸드';
      case RestaurantsCategory.CAFE_DESSERT:
        return '카페/디저트';
    }
  }
}