import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';

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
