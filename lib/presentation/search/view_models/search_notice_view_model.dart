import 'package:dongsoop/presentation/home/state/search_notice_state.dart';
import 'package:dongsoop/providers/search_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:dongsoop/domain/search/use_case/search_notice_use_case.dart';
import 'package:dongsoop/presentation/home/view_models/notice_list_view_model.dart' show NoticeTab;

part 'search_notice_view_model.g.dart';

@Riverpod(keepAlive: true)
class SearchNoticeViewModel extends _$SearchNoticeViewModel {
  late final int _pageSize;
  int _page = 0;
  bool _fetching = false;

  late final SearchNoticeUseCase _useCase;
  late final NoticeTab _tab;
  late final String? _departmentName;

  @override
  SearchNoticeState build({
    required NoticeTab tab,
    String? departmentName,
  }) {
    _tab = tab;
    _departmentName = departmentName;
    _useCase = ref.read(searchNoticeUseCaseProvider);
    _pageSize = _useCase.pageSize;
    return const SearchNoticeState();
  }

  Future<void> search(String keyword) async {
    _page = 0;
    state = state.copyWith(
      keyword: keyword.trim(),
      items: const [],
      isLoading: true,
      hasMore: true,
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
      List<SearchNoticeEntity> pageItems = const [];
      bool hasMore = false;

      switch (_tab) {
        case NoticeTab.school: {
          final next = await _useCase.searchOfficial(
            page: _page,
            keyword: state.keyword,
          );
          hasMore = next.length == _pageSize && next.isNotEmpty;
          pageItems = next;
          if (pageItems.isNotEmpty) _page += 1;
          break;
        }

        case NoticeTab.department: {
          if ((_departmentName ?? '').isEmpty) {
            pageItems = const [];
            hasMore = false;
          } else {
            final next = await _useCase.searchDepartment(
              page: _page,
              keyword: state.keyword,
              departmentName: _departmentName!,
            );
            hasMore = next.length == _pageSize && next.isNotEmpty;
            pageItems = next;
            if (pageItems.isNotEmpty) _page += 1;
          }
          break;
        }

        case NoticeTab.all: {
          final mergedAll = await _useCase.searchCombined(
            page: _page,
            keyword: state.keyword,
            departmentName: _departmentName,
          );

          hasMore = mergedAll.length >= _pageSize && mergedAll.isNotEmpty;

          pageItems = mergedAll.length > _pageSize
              ? mergedAll.sublist(0, _pageSize)
              : mergedAll;

          if (pageItems.isNotEmpty) _page += 1;

          if (pageItems.isEmpty) hasMore = false;
          break;
        }
      }

      final mergedItems = reset ? pageItems : [...state.items, ...pageItems];

      state = state.copyWith(
        items: mergedItems,
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false);
      rethrow;
    } finally {
      _fetching = false;
    }
  }
}
