import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';

class CafeteriaState {
  final bool isLoading;
  final String? error;
  final DailyMealEntity? todayMeal;
  final CafeteriaEmptyReason emptyReason;
  final List<DailyMealEntity> weekMeals;

  const CafeteriaState({
    this.isLoading = false,
    this.error,
    this.todayMeal,
    this.emptyReason = CafeteriaEmptyReason.none,
    this.weekMeals = const [],
  });

  bool get hasWeekMeals => weekMeals.isNotEmpty;
}
