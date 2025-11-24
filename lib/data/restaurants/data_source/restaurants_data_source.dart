import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';

abstract class RestaurantsDataSource {
  Future<List<RestaurantsKakaoInfo>?> searchByKakao(String search);
  Future<bool> checkRestaurantsDuplication(String externalMapId);
  Future<bool> restaurantsRegister(RestaurantsRequest request);
}