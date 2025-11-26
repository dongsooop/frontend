import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class SendRestaurantLikeUseCase {
  final RestaurantsRepository _restaurantsRepository;

  SendRestaurantLikeUseCase(this._restaurantsRepository,);

  Future<bool> execute(int id, bool likedByMe) async {
    return await _restaurantsRepository.like(id, likedByMe);
  }
}
