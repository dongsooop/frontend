import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';

class SearchNoticeState {
  final List<SearchNoticeEntity> items;
  final bool isLoading;
  final bool hasMore;
  final String keyword;

  const SearchNoticeState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.keyword = '',
  });

  SearchNoticeState copyWith({
    List<SearchNoticeEntity>? items,
    bool? isLoading,
    bool? hasMore,
    String? keyword,
  }) {
    return SearchNoticeState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      keyword: keyword ?? this.keyword,
    );
  }
}
