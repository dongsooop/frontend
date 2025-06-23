import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';

abstract class CafeteriaDataSource {
  Future<CafeteriaResponse> fetchCafeteriaMeals();
}
