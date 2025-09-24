import 'package:dongsoop/presentation/board/recruit/list/state/search_recruit_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/providers/search_providers.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/use_case/search_recruit_use_case.dart';

part 'search_recruit_view_model.g.dart';

@riverpod
class SearchRecruitViewModel extends _$SearchRecruitViewModel {
  late final SearchRecruitUseCase _useCase;
  late final RecruitType _type;
  late final String _departmentName;
  late final int _pageSize;

  int _page = 0;
  bool _fetching = false;

  @override
  SearchRecruitState build({
    required RecruitType type,
    required String departmentName,
  }) {
    _type = type;
    _departmentName = departmentName;
    _useCase = ref.read(searchRecruitUseCaseProvider);
    _pageSize = _useCase.pageSize;
    return const SearchRecruitState();
  }

  Future<void> search(String keyword) async {
    _page = 0;
    state = state.copyWith(
      keyword: keyword.trim(),
      items: const [],
      isLoading: true,
      hasMore: true,
      error: null,
    );
    await _fetch(reset: true);
  }

  Future<void> loadMore() async {
    if (_fetching || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
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
        departmentName: _departmentName,
      );

      final hasMore = next.isNotEmpty && next.length == _pageSize;
      if (next.isNotEmpty) _page += 1;

      final merged = reset ? next : [...state.items, ...next];

      state = state.copyWith(
        items: merged,
        isLoading: false,
        hasMore: hasMore,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasMore: false,
        error: e,
      );
    } finally {
      _fetching = false;
    }
  }

  void clear() {
    _page = 0;
    state = const SearchRecruitState();
  }
}
