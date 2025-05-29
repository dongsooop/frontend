import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecruitListState {
  final List<RecruitListEntity> posts;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int page;

  RecruitListState({
    this.posts = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.page = 0,
  });

  RecruitListState copyWith({
    List<RecruitListEntity>? posts,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? page,
  }) {
    return RecruitListState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      page: page ?? this.page,
    );
  }
}

class RecruitListViewModel extends StateNotifier<RecruitListState> {
  final RecruitListUseCase useCase;
  final RecruitType type;
  final String accessToken;
  final String departmentType;

  RecruitListViewModel({
    required this.useCase,
    required this.type,
    required this.accessToken,
    required this.departmentType,
  }) : super(RecruitListState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newPosts = await useCase(
        type: type,
        page: state.page,
        accessToken: accessToken,
        departmentType: departmentType,
      );

      // 모집 중인 게시글만 필터링
      final filteredPosts = newPosts.where((e) => e.state).toList();
      final hasMore = filteredPosts.isNotEmpty;

      state = state.copyWith(
        posts: [...state.posts, ...filteredPosts],
        page: state.page + 1,
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (e) {
      print('[ViewModel] 에러 발생: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void refresh() {
    state = RecruitListState();
    loadNextPage();
  }
}
