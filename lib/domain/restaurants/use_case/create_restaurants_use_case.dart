import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class CreateRestaurantsUseCase {
  final RestaurantsRepository _restaurantsRepository;

  CreateRestaurantsUseCase(this._restaurantsRepository,);

  Future<bool> execute(RestaurantsRequest request) async {
    return await _restaurantsRepository.restaurantsRegister(request);
  }
}
