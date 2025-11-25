import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/restaurants/use_case/get_restaurants_use_case.dart';
import 'package:dongsoop/presentation/restaurants/restaurants_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsViewModel extends StateNotifier<RestaurantsState>{
  final GetRestaurantsUseCase _getRestaurantsUseCase;

  RestaurantsViewModel(
    this._getRestaurantsUseCase,
  ) : super(
      RestaurantsState(isLoading: false)
  );

  // TODO: 조회(비회원)
  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final restaurants = await _getRestaurantsUseCase.execute();
      print('조회 수: ${restaurants?.length ?? 0}');
      (restaurants ?? []).asMap().forEach((index, r) {
        print('[$index] $r');
      });
      (restaurants ?? []).map((e) => e.toString()).join('\n');
      state = state.copyWith(
        isLoading: false,
        restaurants: restaurants,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가게 정보 조회 중 오류가 발생했습니다.\n$e'
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