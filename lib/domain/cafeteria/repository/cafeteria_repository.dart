import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';

abstract class CafeteriaRepository {
  Future<CafeteriaEntity> fetchCafeteriaMeals(); // API 호출 및 캐시 저장
  Future<CafeteriaEntity?> getCachedCafeteriaMeals(); // 로컬 캐시 조회
}
