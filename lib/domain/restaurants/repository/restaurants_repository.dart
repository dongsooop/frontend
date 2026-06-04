import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';

abstract class RestaurantsRepository {
  Future<List<RestaurantsKakaoInfo>?> searchByKakao(String search);
  Future<bool> checkRestaurantsDuplication(String externalMapId);
  Future<bool> restaurantsRegister(RestaurantsRequest request);
  Future<List<Restaurant>?> getRestaurants({
    required bool isLogin,
    RestaurantsCategory? category,
    required int page,
    int size,
  });
  Future<bool> like({
    required int id,
    required bool likedByMe,
  });
  Future<List<Restaurant>?> search({
    required bool isLogin,
    required String search,
    required int page,
    int size,
  });
}