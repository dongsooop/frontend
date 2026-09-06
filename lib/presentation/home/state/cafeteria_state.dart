import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';

class CafeteriaState {
  /// 오늘 급식. 주말·휴무처럼 급식이 없는 날은 null 이다.
  ///
  /// 예전에는 여기에 `오늘은 학식이 제공되지 않아요!` 라는 **문구를** 담았다.
  /// 안내 문구가 데이터 필드에 들어가 있으면 다른 날을 보여줄 때도 "오늘은"
  /// 이라고 말하게 된다. 없음은 값이 아니라 상태로 다룬다.
  final DailyMealEntity? todayMeal;

  final CafeteriaEmptyReason emptyReason;

  /// 이번 주 월~금. 급식이 없는 날은 `koreanMenu` 가 빈 문자열이다.
  final List<DailyMealEntity> weekMeals;

  /// 이번 주 내내 되풀이돼 뒤로 물릴 항목. `findMealStaples` 참고.
  ///
  /// 화면이 이 값을 쓸지는 화면이 정한다. 홈은 뒤로 물리고, 주간을 통째로
  /// 보여줄 화면이라면 그냥 무시하면 된다.
  final List<String> staples;

  const CafeteriaState({
    this.todayMeal,
    this.emptyReason = CafeteriaEmptyReason.none,
    this.weekMeals = const [],
    this.staples = const [],
  });

  bool get hasWeekMeals => weekMeals.isNotEmpty;
}
