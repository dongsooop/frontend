import 'package:dongsoop/domain/mypage/use_case/get_my_recruit_posts_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_recruit_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityRecruitViewModel extends StateNotifier<ActivityRecruitState> {
  final GetMyRecruitPostsUseCase _getMyRecruitPostsUseCase;

  ActivityRecruitViewModel(
    this._getMyRecruitPostsUseCase,
  ) : super(ActivityRecruitState(isLoading: false));

  Future<void> loadPosts(bool isApply) async {
    state = state.copyWith(isLoading: true, errorMessage: null,);

    try {
      final posts = await _getMyRecruitPostsUseCase.execute(isApply: isApply) ?? [];

      state = state.copyWith(isLoading: false, posts: posts);
    } catch (e, st) {
      logger.e('load posts error: ${e.runtimeType}', error: e, stackTrace: st);
      state = state.copyWith(
        isLoading: false,
        errorMessage: '모집 목록을 불러오는 중\n오류가 발생했습니다.',
      );
    }
  }

  // 페이징
  Future<void> fetchNextPage(bool isApply) async {
    if (!state.hasNext || state.isLoading) return; // 이미 끝이거나 로딩 중이면 무시

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.page + 1;
      final newPosts= await _getMyRecruitPostsUseCase.execute(isApply: isApply, page: nextPage, size: 10);

      final isLast = newPosts == null || newPosts.length < 10;
      state = state.copyWith(
        isLoading: false,
        posts: [...(state.posts ?? []), ...?newPosts],
        page: nextPage,
        hasNext: !isLast,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '모집 목록을 불러오는 중 오류가 발생했습니다.');
    }
  }
}
