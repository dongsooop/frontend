import 'package:dongsoop/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/mypage/use_case/get_my_market_posts_use_case.dart';
import 'activity_market_state.dart';

class ActivityMarketViewModel extends StateNotifier<ActivityMarketState> {
  final GetMyMarketPostsUseCase _getMyMarketPostsUseCase;

  ActivityMarketViewModel(
    this._getMyMarketPostsUseCase,
  ) : super(ActivityMarketState(isLoading: false));

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null,);

    try {
      final posts = await _getMyMarketPostsUseCase.execute() ?? [];

      state = state.copyWith(isLoading: false, posts: posts);
    } catch (e, st) {
      logger.e('load posts error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '장터 목록을 불러오는 중\n오류가 발생했습니다.',
      );
    }
  }

  // 페이징
  Future<void> fetchNextPage() async {
    if (!state.hasNext || state.isLoading) return; // 이미 끝이거나 로딩 중이면 무시

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.page + 1;
      final newPosts= await _getMyMarketPostsUseCase.execute(page: nextPage, size: 10);

      final isLast = newPosts == null || newPosts.length < 10;
      state = state.copyWith(
        isLoading: false,
        posts: [...(state.posts ?? []), ...?newPosts],
        page: nextPage,
        hasNext: !isLast,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '장터 목록을 불러오는 중 오류가 발생했습니다.');
    }
  }
}
