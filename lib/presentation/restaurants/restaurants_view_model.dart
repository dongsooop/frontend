import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/use_case/get_restaurants_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/send_restaurant_like_use_case.dart';
import 'package:dongsoop/presentation/restaurants/restaurants_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsViewModel extends StateNotifier<RestaurantsState>{
  final GetRestaurantsUseCase _getRestaurantsUseCase;
  final SendRestaurantLikeUseCase _sendRestaurantLikeUseCase;

  RestaurantsViewModel(
    this._getRestaurantsUseCase,
    this._sendRestaurantLikeUseCase,
  ) : super(
      RestaurantsState(isLoading: false)
  );

  // 카테고리별 현재 페이지
  final Map<RestaurantsCategory?, int> _pageByCategory = {};
  // 카테고리별 다음 페이지 유무
  final Map<RestaurantsCategory?, bool> _hasNextByCategory = {};
  // 페이징 중복 요청 방지
  bool _isLoadingMore = false;

  Future<void> loadRestaurants({
    RestaurantsCategory? category,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _getRestaurantsUseCase.execute(
        category: category,
        page: 0,
        size: 20,
      );

      // print('조회 수: ${result?.length ?? 0}');
      // (result ?? []).asMap().forEach((index, r) {
      //   print('[$index] $r');
      // });

      _pageByCategory[category] = 0;
      _hasNextByCategory[category] = (result?.length ?? 0) == 20;

      state = state.copyWith(
        isLoading: false,
        restaurants: result ?? [],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가게 정보 조회 중 오류가 발생했습니다.'
      );
    }
  }

  Future<void> loadNextPage({RestaurantsCategory? category}) async {
    if (_isLoadingMore) return;
    // 더 불러올 게 없으면 종료
    if (_hasNextByCategory[category] == false) return;

    _isLoadingMore = true;
    try {
      final currentPage = _pageByCategory[category] ?? 0;
      final nextPage = currentPage + 1;

      final result = await _getRestaurantsUseCase.execute(
        category: category,
        page: nextPage,
        size: 20,
      );

      _pageByCategory[category] = nextPage;
      _hasNextByCategory[category] = (result?.length ?? 0) == 20;

      final currentList = state.restaurants ?? [];
      state = state.copyWith(
        restaurants: [
          ...currentList,
          ...?result,
        ],
      );
    } catch (e) {
      state = state.copyWith(errorMessage: '가게 정보 조회 중 오류가 발생했습니다.');
    } finally {
      _isLoadingMore = false;
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