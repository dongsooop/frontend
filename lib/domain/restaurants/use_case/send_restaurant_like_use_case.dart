import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class SendRestaurantLikeUseCase {
  final RestaurantsRepository _restaurantsRepository;

  SendRestaurantLikeUseCase(this._restaurantsRepository,);

  Future<bool> execute({
    required int id,
    required bool likedByMe,
  }) async {
    return await _restaurantsRepository.like(
      id: id,
      likedByMe: likedByMe,
    );
  }
}
