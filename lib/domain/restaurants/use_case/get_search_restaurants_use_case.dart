import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class GetSearchRestaurantsUseCase {
  final RestaurantsRepository _restaurantsRepository;

  GetSearchRestaurantsUseCase(this._restaurantsRepository,);

  Future<List<Restaurant>?> execute({
    required bool isLogin,
    required String search,
    required int page,
    int size = 20,
  }) async {
    return await _restaurantsRepository.search(
      isLogin: isLogin,
      search: search,
      page: page,
      size: size
    );
  }
}
