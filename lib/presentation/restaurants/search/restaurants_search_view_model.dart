import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/presentation/restaurants/search/restaurants_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsSearchViewModel extends StateNotifier<RestaurantsSearchState>{

  RestaurantsSearchViewModel(
    ) : super(
    RestaurantsSearchState(isLoading: false)
  );

  // TODO: 조회(비회원)
  Future<void> search() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      state = state.copyWith(
        isLoading: false,
        // restaurants: restaurants,
      );
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: '가게 정보 검색 중 오류가 발생했습니다.'
      );
    }
  }

  // TODO: 좋아요 기능(회원)
  Future<void> like() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
    } on RestaurantsDuplicationException catch (e) {
    } catch (e) {
    }
  }
}