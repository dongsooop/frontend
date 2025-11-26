import 'package:dongsoop/domain/restaurants/use_case/send_restaurant_like_use_case.dart';
import 'package:dongsoop/presentation/restaurants/search/restaurants_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsSearchViewModel extends StateNotifier<RestaurantsSearchState>{
  final SendRestaurantLikeUseCase _sendRestaurantLikeUseCase;

  RestaurantsSearchViewModel(
    this._sendRestaurantLikeUseCase
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

  Future<void> like(int id, bool likedByMe) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _sendRestaurantLikeUseCase.execute(id, likedByMe);
      if (!result) return;

      final current = state.restaurants ?? [];
      final updated = current.map((r) {
        if (r.id != id) return r;

        final newLiked = !likedByMe;
        final newCount = newLiked ? r.likeCount + 1 : r.likeCount - 1;

        return r.copyWith(
          likedByMe: newLiked,
          likeCount: newCount < 0 ? 0 : newCount,
        );
      }).toList();

      state = state.copyWith(
        isLoading: false,
        restaurants: updated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가게 추천 중 오류가 발생했습니다.',
      );
    }
  }
}