import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/repository/cafeteria_repository.dart';

class CafeteriaUseCase {
  final CafeteriaRepository repository;

  CafeteriaUseCase(this.repository);

  Future<CafeteriaEntity> execute() async {
    final cached = await repository.getCachedCafeteriaMeals();
    if (cached != null) return cached;

    return await repository.fetchCafeteriaMeals();
  }
}
