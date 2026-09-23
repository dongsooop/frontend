class CafeteriaEntity {
  final String startDate;
  final String endDate;
  final List<DailyMealEntity> dailyMeals;

  /// 그 주 공지. 없으면 null 이다.
  final String? notice;

  CafeteriaEntity({
    required this.startDate,
    required this.endDate,
    required this.dailyMeals,
    this.notice,
  });
}

class DailyMealEntity {
  final String date;
  final String dayOfWeek;
  final String koreanMenu;

  /// 단품 메뉴. 받지 못한 날은 빈 문자열이다 — 한식과 같은 규칙으로 다룬다.
  final String specialMenu;

  DailyMealEntity({
    required this.date,
    required this.dayOfWeek,
    required this.koreanMenu,
    this.specialMenu = '',
  });
}
