import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:dongsoop/data/cafeteria/model/meal_price_response.dart';

abstract class CafeteriaDataSource {
  Future<CafeteriaResponse> fetchCafeteriaMeals();
  Future<MealPriceResponse> fetchMealPrices();
}
