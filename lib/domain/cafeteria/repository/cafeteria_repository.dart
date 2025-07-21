import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';

abstract class CafeteriaRepository {
  Future<CafeteriaEntity> fetchCafeteriaMeals();
  Future<CafeteriaEntity?> getCachedCafeteriaMeals();
}
