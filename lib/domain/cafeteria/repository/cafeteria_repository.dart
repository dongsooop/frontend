import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';

abstract class CafeteriaRepository {
  Future<CafeteriaEntity> fetchCafeteriaMeals();
  Future<CafeteriaEntity?> getCachedCafeteriaMeals();
  Future<MealPriceEntity> fetchMealPrices();
}
