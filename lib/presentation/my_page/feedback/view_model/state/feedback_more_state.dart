class FeedbackMoreState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? errMessage;
  final List<String> items;

  const FeedbackMoreState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 0,
    this.errMessage,
    this.items = const [],
  });

  bool get hasData => items.isNotEmpty;

  FeedbackMoreState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? errMessage,
    List<String>? items,
  }) {
    return FeedbackMoreState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errMessage: errMessage,
      items: items ?? this.items,
    );
  }
}