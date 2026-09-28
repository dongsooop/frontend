/// 식권·단품 가격표.
///
/// 학교 식단 페이지에는 가격이 없어 서버 설정 파일(`meal.prices`)이 들고
/// 있다. 그래서 주간 식단과 달리 날짜와 무관하고, 배포 전까지 바뀌지 않는다.
class MealPriceEntity {
  /// 한식 식권 한 장 값.
  final int ticketPrice;

  final List<MealPriceCategoryEntity> categories;

  const MealPriceEntity({
    required this.ticketPrice,
    required this.categories,
  });
}

class MealPriceCategoryEntity {
  final String name;

  /// `공기밥 포함` 처럼 그 묶음 전체에 걸리는 단서. 없으면 null 이다.
  final String? note;

  final List<MealPriceItemEntity> items;

  const MealPriceCategoryEntity({
    required this.name,
    required this.items,
    this.note,
  });
}

class MealPriceItemEntity {
  final String name;
  final int price;

  /// 곱빼기 값. 곱빼기가 없는 메뉴는 null 이다.
  final int? largePrice;

  /// 파는 요일. 비어 있으면 매일 판다.
  final List<String> days;

  const MealPriceItemEntity({
    required this.name,
    required this.price,
    this.largePrice,
    this.days = const [],
  });

  bool get isEveryday => days.isEmpty;
}
