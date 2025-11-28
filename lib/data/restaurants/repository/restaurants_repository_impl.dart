import 'package:dongsoop/data/restaurants/data_source/restaurants_data_source.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';

class RestaurantsRepositoryImpl implements RestaurantsRepository{
  final RestaurantsDataSource _reportDataSource;

  RestaurantsRepositoryImpl(this._reportDataSource,);

  @override
  Future<List<RestaurantsKakaoInfo>?> searchByKakao(String search) async {
    return await _reportDataSource.searchByKakao(search);
  }

  @override
  Future<bool> checkRestaurantsDuplication(String externalMapId) async {
    return await _reportDataSource.checkRestaurantsDuplication(externalMapId);
  }

  @override
  Future<bool> restaurantsRegister(RestaurantsRequest request) async {
    return await _reportDataSource.restaurantsRegister(request);
  }

  @override
  Future<List<Restaurant>?> getRestaurants({
    required bool isLogin,
    RestaurantsCategory? category,
    required int page,
    int size = 20,
  }) async {
    return await _reportDataSource.getRestaurants(
      isLogin: isLogin,
      category: category,
      page: page,
      size: size,
    );
  }

  @override
  Future<bool> like({
    required int id,
    required bool likedByMe,
  }) async {
    return await _reportDataSource.like(
      id: id,
      likedByMe: likedByMe,
    );
  }

  @override
  Future<List<Restaurant>?> search({
    required bool isLogin,
    required String search,
    required int page,
    int size = 20,
  }) async {
    return await _reportDataSource.search(
      isLogin: isLogin,
      search: search,
      page: page,
      size: size
    );
  }
}