import 'package:dongsoop/domain/restaurants/use_case/get_search_restaurants_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/send_restaurant_like_use_case.dart';
import 'package:dongsoop/presentation/restaurants/search/restaurants_search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantsSearchViewModel extends StateNotifier<RestaurantsSearchState>{
  final GetSearchRestaurantsUseCase _getSearchRestaurantsUseCase;
  final SendRestaurantLikeUseCase _sendRestaurantLikeUseCase;

  RestaurantsSearchViewModel(
    this._getSearchRestaurantsUseCase,
    this._sendRestaurantLikeUseCase
  ) : super(
    RestaurantsSearchState(isLoading: false)
  );

  int _currentPage = 0;
  int _pageSize = 20;
  bool _hasNextPage = true;
  String _lastSearch = '';

  void reset() {
    _currentPage = 0;
    _hasNextPage = true;
    _lastSearch = '';

    state = RestaurantsSearchState(isLoading: false);
  }

  Future<void> search({
    required bool isLogin,
    required String search,
  }) async {
    _currentPage = 0;
    _hasNextPage = true;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _getSearchRestaurantsUseCase.execute(
        isLogin: isLogin,
        search: search,
        page: 0,
      );
      final list = result ?? [];

      state = state.copyWith(
        isLoading: false,
        isNoSearchResult: list.isEmpty,
        restaurants: list,
      );
      _hasNextPage = list.length == _pageSize;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '가게 정보 검색 중 오류가 발생했습니다.',
      );
    }
  }

  Future<void> loadNextPage({
    required bool isLogin,
  }) async {
    if (!_hasNextPage) return;

    final nextPage = _currentPage + 1;

    try {
      final result = await _getSearchRestaurantsUseCase.execute(
        isLogin: isLogin,
        search: _lastSearch,
        page: nextPage,
        size: _pageSize,
      );
      final list = result ?? [];

      _hasNextPage = list.length == _pageSize;
      _currentPage = nextPage;

      final current = state.restaurants ?? [];
      state = state.copyWith(
        restaurants: [
          ...current,
          ...list,
        ],
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: '가게 정보 검색 중 오류가 발생했습니다.',
      );
    }
  }

  Future<void> like({
    required int id,
    required bool likedByMe,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _sendRestaurantLikeUseCase.execute(
        id: id,
        likedByMe: likedByMe,
      );
      if (!result) return;

      final current = state.restaurants ?? [];
      final updated = current.map((r) {
        if (r.id != id) return r;

        final newLiked = !likedByMe;
        final newCount = newLiked ? r.likeCount + 1 : r.likeCount - 1;

        return r.copyWith(
          isLikedByMe: newLiked,
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