import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class CheckRestaurantsDuplicationUseCase {
  final RestaurantsRepository _restaurantsRepository;

  CheckRestaurantsDuplicationUseCase(this._restaurantsRepository,);

  Future<bool> execute(String externalMapId) async {
    return await _restaurantsRepository.checkRestaurantsDuplication(externalMapId);
  }
}
