import 'package:dongsoop/domain/mypage/model/mypage_market.dart';

class ActivityMarketState {
  final bool isLoading;
  final String? errorMessage;
  final List<MypageMarket>? posts;
  final int page;
  final bool hasNext;

  ActivityMarketState({
    required this.isLoading,
    this.errorMessage,
    this.posts = const [],
    this.page = 0,
    this.hasNext = true,
  });

  ActivityMarketState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MypageMarket>? posts,
    int? page,
    bool? hasNext,
  }) {
    return ActivityMarketState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasNext: hasNext ?? this.hasNext,
    );
  }
}
