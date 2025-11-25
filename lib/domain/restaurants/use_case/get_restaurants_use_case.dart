import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantsRepository _restaurantsRepository;

  GetRestaurantsUseCase(this._restaurantsRepository,);

  Future<List<Restaurant>?> execute() async {
    return await _restaurantsRepository.getRestaurants();
  }
}
