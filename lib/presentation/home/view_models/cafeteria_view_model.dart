import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/providers/cafeteria_use_case_provider.dart';
import 'package:dongsoop/presentation/home/state/cafeteria_state.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cafeteria_view_model.g.dart';

enum CafeteriaEmptyReason {
  none,
  weekend,
  holiday,
  noData,
  error,
}

@riverpod
class CafeteriaViewModel extends _$CafeteriaViewModel {
  @override
  FutureOr<CafeteriaState> build() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final useCase = ref.read(cafeteriaUseCaseProvider);
    final entity = await useCase.execute();

    final todayMeal = entity.dailyMeals.firstWhere(
          (m) => m.date == today,
      orElse: () => DailyMealEntity(
        date: today,
        dayOfWeek: '',
        koreanMenu: '',
      ),
    );

    DateTime monday(DateTime d) => d.subtract(Duration(days: d.weekday - 1));
    final start = monday(now);

    final weekDateTimes = List.generate(7, (i) => start.add(Duration(days: i)));
    final weekDaysStr = weekDateTimes
        .map((d) => DateFormat('yyyy-MM-dd').format(d))
        .toList(growable: false);

    final weekMeals = <DailyMealEntity>[];
    for (var i = 0; i < 7; i++) {
      final dateStr = weekDaysStr[i];
      final dow = weekDateTimes[i].weekday;

      final fromEntity = entity.dailyMeals.firstWhere(
            (m) => m.date == dateStr,
        orElse: () => DailyMealEntity(
          date: dateStr,
          dayOfWeek: '',
          koreanMenu: '',
        ),
      );

      final isWeekendDay = dow >= 6;
      final menu = (isWeekendDay || fromEntity.koreanMenu.trim().isEmpty)
          ? '오늘은 학식이 제공되지 않아요!'
          : fromEntity.koreanMenu;

      weekMeals.add(
        DailyMealEntity(
          date: dateStr,
          dayOfWeek: fromEntity.dayOfWeek,
          koreanMenu: menu,
        ),
      );
    }

    final isWeekendToday = now.weekday >= 6;
    final isHolidayToday = todayMeal.koreanMenu.trim().length < 10;

    if (isWeekendToday) {
      return CafeteriaState(
        todayMeal: DailyMealEntity(
          date: today,
          dayOfWeek: '',
          koreanMenu: '오늘은 학식이 제공되지 않아요!',
        ),
        emptyReason: CafeteriaEmptyReason.weekend,
        weekMeals: weekMeals,
      );
    }

    if (isHolidayToday) {
      return CafeteriaState(
        todayMeal: DailyMealEntity(
          date: today,
          dayOfWeek: todayMeal.dayOfWeek,
          koreanMenu: '오늘은 학식이 제공되지 않아요!',
        ),
        emptyReason: CafeteriaEmptyReason.holiday,
        weekMeals: weekMeals,
      );
    }

    return CafeteriaState(
      todayMeal: todayMeal,
      weekMeals: weekMeals,
    );
  }
}
