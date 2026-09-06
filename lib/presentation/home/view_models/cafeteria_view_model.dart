import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/meal_menu.dart';
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

/// 서버가 내려주는 급식일. 월~금뿐이고 주말 데이터는 존재하지 않는다.
const int _servedDaysInWeek = 5;

const List<String> _weekdayNames = ['월', '화', '수', '목', '금'];

@riverpod
class CafeteriaViewModel extends _$CafeteriaViewModel {
  @override
  FutureOr<CafeteriaState> build() async {
    final useCase = ref.read(cafeteriaUseCaseProvider);
    final entity = await useCase.execute();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    final weekMeals = _buildWeek(monday, entity.dailyMeals);

    // 되풀이 판정은 한 주를 통째로 보고 한 번만 한다. 위젯에서 하면
    // rebuild 마다 다시 센다
    final staples = findMealStaples(weekMeals);

    if (weekMeals.every((meal) => meal.koreanMenu.isEmpty)) {
      return CafeteriaState(
        emptyReason: CafeteriaEmptyReason.noData,
        weekMeals: weekMeals,
        staples: staples,
      );
    }

    final todayKey = DateFormat('yyyy-MM-dd').format(today);
    final todayMeal = _firstServed(
      weekMeals.where((meal) => meal.date == todayKey),
    );

    if (todayMeal != null) {
      return CafeteriaState(
        todayMeal: todayMeal,
        weekMeals: weekMeals,
        staples: staples,
      );
    }

    // 오늘은 급식이 없다. 판은 이번 주 전체를 보여주므로 그대로 둔다
    final isWeekend = today.weekday > _servedDaysInWeek;

    return CafeteriaState(
      emptyReason: isWeekend
          ? CafeteriaEmptyReason.weekend
          : CafeteriaEmptyReason.holiday,
      weekMeals: weekMeals,
      staples: staples,
    );
  }

  /// 이번 주 월~금을 빠짐없이 채운다.
  ///
  /// 응답에 빠진 날과 서버가 `식단 정보 없음` 으로 채워 보낸 날은 모두 빈
  /// 메뉴로 둔다. 안내 문구를 여기에 넣지 않는다 — 그건 화면이 할 말이다.
  List<DailyMealEntity> _buildWeek(
    DateTime monday,
    List<DailyMealEntity> dailyMeals,
  ) {
    return List.generate(
      _servedDaysInWeek,
      (index) {
        final date = monday.add(Duration(days: index));
        final key = DateFormat('yyyy-MM-dd').format(date);
        DailyMealEntity? found;
        for (final meal in dailyMeals) {
          if (meal.date == key) {
            found = meal;
            break;
          }
        }

        final menu = found == null || isMealEmpty(found.koreanMenu)
            ? ''
            : found.koreanMenu;
        final dayOfWeek = found != null && found.dayOfWeek.isNotEmpty
            ? found.dayOfWeek
            : _weekdayNames[index];

        return DailyMealEntity(
          date: key,
          dayOfWeek: dayOfWeek,
          koreanMenu: menu,
        );
      },
      growable: false,
    );
  }

  /// 메뉴가 실제로 있는 첫 날. `firstOrNull` 은 package:collection 의 확장이라
  /// 이 파일에서 굳이 끌어오지 않는다.
  DailyMealEntity? _firstServed(Iterable<DailyMealEntity> meals) {
    for (final meal in meals) {
      if (meal.koreanMenu.isNotEmpty) return meal;
    }
    return null;
  }
}
