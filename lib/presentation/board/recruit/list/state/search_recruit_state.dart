import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';

class SearchRecruitState {
  final String keyword;
  final List<SearchRecruitEntity> items;
  final bool isLoading;
  final bool hasMore;
  final Object? error;

  const SearchRecruitState({
    this.keyword = '',
    this.items = const <SearchRecruitEntity>[],
    this.isLoading = false,
    this.hasMore = false,
    this.error,
  });

  SearchRecruitState copyWith({
    String? keyword,
    List<SearchRecruitEntity>? items,
    bool? isLoading,
    bool? hasMore,
    Object? error,
  }) {
    return SearchRecruitState(
      keyword: keyword ?? this.keyword,
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}