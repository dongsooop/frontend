import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class SearchKakaoUseCase {
  final RestaurantsRepository _restaurantsRepository;

  SearchKakaoUseCase(this._restaurantsRepository,);

  Future<List<RestaurantsKakaoInfo>?> execute(String search) async {
    return await _restaurantsRepository.searchByKakao(search);
  }
}
