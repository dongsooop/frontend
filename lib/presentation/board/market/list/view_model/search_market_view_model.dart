import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/search/entity/search_market_entity.dart';
import 'package:dongsoop/domain/search/use_case/search_market_use_case.dart';
import 'package:dongsoop/presentation/board/market/state/search_market_state.dart';
import 'package:dongsoop/providers/search_providers.dart';

part 'search_market_view_model.g.dart';

@Riverpod(keepAlive: true)
class SearchMarketViewModel extends _$SearchMarketViewModel {
  late SearchMarketUseCase _useCase;
  late MarketType _type;
  late int _pageSize;

  int _page = 0;
  bool _fetching = false;

  @override
  SearchMarketState build({ required MarketType type }) {
    _type = type;
    _useCase = ref.read(searchMarketUseCaseProvider);
    _pageSize = _useCase.pageSize;
    return SearchMarketState.initial();
  }

  Future<void> search(String keyword) async {
    final q = keyword.trim();
    if (q.isEmpty) return;

    _page = 0;
    state = state.copyWith(
      keyword: q,
      items: const <SearchMarketEntity>[],
      isLoading: true,
      hasMore: true,
      error: null, // ← 에러 초기화
    );
    await _fetch(reset: true);
  }

  Future<void> loadMore() async {
    if (_fetching || !state.hasMore) return;
    state = state.copyWith(isLoading: true);
    await _fetch();
  }

  Future<void> _fetch({bool reset = false}) async {
    if (_fetching) return;
    _fetching = true;

    try {
      final next = await _useCase.execute(
        page: _page,
        keyword: state.keyword,
        type: _type,
      );

      final hasMore = next.isNotEmpty && next.length == _pageSize;
      if (next.isNotEmpty) _page += 1;

      final merged = reset ? next : <SearchMarketEntity>[...state.items, ...next];

      state = state.copyWith(
        items: merged,
        isLoading: false,
        hasMore: hasMore,
        error: null, // 성공 시 에러 클리어
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e,
      );
      rethrow;
    } finally {
      _fetching = false;
    }
  }

  void clear() {
    _page = 0;
    state = SearchMarketState.initial();
  }
}
