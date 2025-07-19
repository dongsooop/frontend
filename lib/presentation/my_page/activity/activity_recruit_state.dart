import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';

class ActivityRecruitState {
  final bool isLoading;
  final String? errorMessage;
  final List<MypageRecruit>? posts;
  final int page;
  final bool hasNext;

  ActivityRecruitState({
    required this.isLoading,
    this.errorMessage,
    this.posts = const [],
    this.page = 0,
    this.hasNext = true,
  });

  ActivityRecruitState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MypageRecruit>? posts,
    int? page,
    bool? hasNext,
  }) {
    return ActivityRecruitState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
