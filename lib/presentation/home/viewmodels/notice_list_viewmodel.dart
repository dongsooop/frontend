import 'package:dongsoop/domain/entites/home/notice_entity.dart';
import 'package:dongsoop/domain/usecases/home/notice_usecase.dart';
import 'package:dongsoop/presentation/home/viewmodels/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// /// 필터 타입 정의
// enum NoticeFilterType { all, school, department }

/// 리스트 뷰모델 Provider
final noticeListViewModelProvider =
    StateNotifierProvider<NoticeListViewModel, AsyncValue<List<NoticeEntity>>>(
  (ref) => NoticeListViewModel(ref.watch(noticeUseCaseProvider)),
);

/// 리스트 뷰모델 정의
class NoticeListViewModel
    extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;

  NoticeListViewModel(this.useCase) : super(const AsyncLoading()) {
    fetchNextPage(); // 초기 로딩 = page 0
  }

  int _page = 0;
  bool _isLastPage = false;
  bool _isLoading = false;

  List<NoticeEntity> _all = [];
  // NoticeFilterType _currentFilter = NoticeFilterType.all;

  /// 다음 페이지 데이터를 불러오고 누적
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
        // _applyFilter(); // 필터 적용 후 state 업데이트
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }

  // /// 현재 필터 기준으로 리스트 필터링 적용
  // void _applyFilter() {
  //   List<NoticeEntity> filtered;
  //   switch (_currentFilter) {
  //     case NoticeFilterType.all:
  //       filtered = _all;
  //       break;
  //     case NoticeFilterType.school:
  //       filtered = _all.where((e) => e.department_code == 'DEPT_1001').toList();
  //       break;
  //     case NoticeFilterType.department:
  //       filtered = _all.where((e) => e.department_code != 'DEPT_1001').toList();
  //       break;
  //   }
  //   state = AsyncValue.data(filtered);
  // }
  //
  // /// 필터 변경 시 호출
  // void filterBy(NoticeFilterType type) {
  //   _currentFilter = type;
  //   _applyFilter();
  // }
}
