import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/providers/cafeteria_use_case_provider.dart';
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

class CafeteriaState {
  final bool isLoading;
  final String? error;
  final DailyMealEntity? todayMeal;
  final CafeteriaEmptyReason emptyReason;

  const CafeteriaState({
    this.isLoading = false,
    this.error,
    this.todayMeal,
    this.emptyReason = CafeteriaEmptyReason.none,
  });
}

@riverpod
class CafeteriaViewModel extends _$CafeteriaViewModel {
  @override
  FutureOr<CafeteriaState> build() async {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    final isWeekend = now.weekday >= 6; // 토, 일
    if (isWeekend) {
      return CafeteriaState(
        todayMeal: DailyMealEntity(
          date: today,
          dayOfWeek: '',
          koreanMenu: '오늘은 학식이 제공되지 않아요!',
        ),
        emptyReason: CafeteriaEmptyReason.weekend,
      );
    }

    try {
      final useCase = ref.read(cafeteriaUseCaseProvider);
      final entity = await useCase.execute();

      final todayMeal = entity.dailyMeals.firstWhere(
        (meal) => meal.date == today,
        orElse: () => DailyMealEntity(
          date: today,
          dayOfWeek: '',
          koreanMenu: '',
        ),
      );

      final isHoliday = todayMeal.koreanMenu.trim().length < 10;
      if (isHoliday) {
        return CafeteriaState(
          todayMeal: DailyMealEntity(
            date: today,
            dayOfWeek: todayMeal.dayOfWeek,
            koreanMenu: '오늘은 학식이 제공되지 않아요!',
          ),
          emptyReason: CafeteriaEmptyReason.holiday,
        );
      }

      return CafeteriaState(todayMeal: todayMeal);
    } catch (e) {
      return CafeteriaState(
        error: e.toString(),
        emptyReason: CafeteriaEmptyReason.error,
      );
    }
  }
}
