import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantsRepository _restaurantsRepository;

  GetRestaurantsUseCase(this._restaurantsRepository,);

  Future<List<Restaurant>?> execute({
    RestaurantsCategory? category,
    required int page,
    int size = 20,
  }) async {
    return await _restaurantsRepository.getRestaurants(
      category: category,
      page: page,
      size: size,
    );
  }
}
