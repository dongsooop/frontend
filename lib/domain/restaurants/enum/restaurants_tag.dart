enum RestaurantsTag {
  LARGE_PORTION,
  DELICIOUS,
  GOOD_FOR_LUNCH,
  GOOD_FOR_SOLO,
  GOOD_VALUE,
  GOOD_FOR_GATHERING,
  GOOD_FOR_CONVERSATION,
  VARIOUS_MENU,
}

extension RestaurantsTagLabel on RestaurantsTag {
  String get label {
    switch (this) {
      case RestaurantsTag.LARGE_PORTION:
        return '양이 많아요';
      case RestaurantsTag.DELICIOUS:
        return '음식이 맛있어요';
      case RestaurantsTag.GOOD_FOR_LUNCH:
        return '점심으로 괜찮아요';
      case RestaurantsTag.GOOD_FOR_SOLO:
        return '혼밥하기 좋아요';
      case RestaurantsTag.GOOD_VALUE:
        return '가성비가 좋아요';
      case RestaurantsTag.GOOD_FOR_GATHERING:
        return '회식하기 좋아요';
      case RestaurantsTag.GOOD_FOR_CONVERSATION:
        return '대화하기 괜찮아요';
      case RestaurantsTag.VARIOUS_MENU:
        return '메뉴가 다양해요';
    }
  }
}