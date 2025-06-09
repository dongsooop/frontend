class CafeteriaEntity {
  final String startDate;
  final String endDate;
  final List<DailyMealEntity> dailyMeals;

  CafeteriaEntity({
    required this.startDate,
    required this.endDate,
    required this.dailyMeals,
  });
}

class DailyMealEntity {
  final String date;
  final String dayOfWeek;
  final String koreanMenu;

  DailyMealEntity({
    required this.date,
    required this.dayOfWeek,
    required this.koreanMenu,
  });
}
