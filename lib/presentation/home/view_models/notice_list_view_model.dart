import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_usecase.dart';
import 'package:dongsoop/presentation/home/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공지 리스트 뷰모델 Provider (학교 공지만 가져옴)
final noticeListViewModelProvider =
    StateNotifierProvider<NoticeListViewModel, AsyncValue<List<NoticeEntity>>>(
  (ref) => NoticeListViewModel(ref.watch(noticeUseCaseProvider)),
);

/// 공지 리스트 뷰모델 (서버 페이징 기반)
class NoticeListViewModel
    extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;

  NoticeListViewModel(this.useCase) : super(const AsyncLoading()) {
    fetchNextPage(); // 초기 로딩
  }

  int _page = 0;
  bool _isLastPage = false;
  bool _isLoading = false;
  final List<NoticeEntity> _all = [];

  Future<void> fetchNextPage() async {
    if (_isLoading || _isLastPage) return;
    _isLoading = true;

    try {
      final newItems = await useCase(page: _page);

      if (newItems.isEmpty) {
        _isLastPage = true;
      } else {
        _page++;
        _all.addAll(newItems);
        state = AsyncValue.data(_all);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }
}
