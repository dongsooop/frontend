import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_list_use_case.dart';
import 'package:dongsoop/presentation/board/market/state/market_list_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_list_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_list_view_model.g.dart';

@riverpod
class MarketListViewModel extends _$MarketListViewModel {
  late final MarketListUseCase _useCase;
  late final MarketType _type;

  @override
  MarketListState build({required MarketType type}) {
    _useCase = ref.watch(marketListUseCaseProvider);
    _type = type;

    Future.microtask(() => _fetchInitial());
    return MarketListState();
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(isLoading: true, error: null, page: 0);

    try {
      final result = await _useCase.execute(type: _type, page: 0);
      state = state.copyWith(
        items: result,
        isLoading: false,
        hasMore: result.length == 10,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchNext() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final result = await _useCase.execute(type: _type, page: state.page);
      state = state.copyWith(
        items: [...state.items, ...result],
        isLoading: false,
        hasMore: result.length == 10,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);

    try {
      final result = await _useCase.execute(type: _type, page: 0);
      state = state.copyWith(
        items: result,
        isRefreshing: false,
        hasMore: result.length == 10,
        page: 1,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    }
  }
}
