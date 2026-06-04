import 'package:dongsoop/domain/search/entity/search_market_entity.dart';

class SearchMarketState {
  final String keyword;
  final List<SearchMarketEntity> items;
  final bool isLoading;
  final bool hasMore;
  final Object? error;

  const SearchMarketState({
    this.keyword = '',
    this.items = const <SearchMarketEntity>[],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  SearchMarketState copyWith({
    String? keyword,
    List<SearchMarketEntity>? items,
    bool? isLoading,
    bool? hasMore,
    Object? error,
  }) {
    return SearchMarketState(
      keyword: keyword ?? this.keyword,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
  factory SearchMarketState.initial() => const SearchMarketState();
}
