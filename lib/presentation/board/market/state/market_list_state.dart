import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';

class MarketListState {
  final List<MarketListEntity> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasMore;
  final String? error;
  final int page;

  MarketListState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasMore = true,
    this.error,
    this.page = 0,
  });

  MarketListState copyWith({
    List<MarketListEntity>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasMore,
    String? error,
    int? page,
  }) {
    return MarketListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      page: page ?? this.page,
    );
  }
}
