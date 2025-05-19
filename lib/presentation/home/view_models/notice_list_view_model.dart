import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_use_case.dart';
import 'package:dongsoop/presentation/home/providers/notice_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 탭 + 학과 코드 정보를 담는 args 클래스
class NoticeListArgs {
  final NoticeTab tab;
  final String? departmentType;

  const NoticeListArgs({
    required this.tab,
    this.departmentType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoticeListArgs &&
          runtimeType == other.runtimeType &&
          tab == other.tab &&
          departmentType == other.departmentType;

  @override
  int get hashCode => tab.hashCode ^ (departmentType?.hashCode ?? 0);
}

final noticeListViewModelProvider = StateNotifierProvider.family<
    NoticeListViewModel,
    AsyncValue<List<NoticeEntity>>,
    NoticeListArgs>((ref, args) {
  return NoticeListViewModel(
    useCase: ref.watch(noticeUseCaseProvider),
    tab: args.tab,
    departmentType: args.departmentType,
  );
});

class NoticeListViewModel
    extends StateNotifier<AsyncValue<List<NoticeEntity>>> {
  final NoticeUseCase useCase;
  final NoticeTab tab;
  final String? departmentType;

  NoticeListViewModel({
    required this.useCase,
    required this.tab,
    required this.departmentType,
  }) : super(const AsyncLoading()) {
    fetchNextPage();
  }

  int _page = 0;
  bool _isLastPage = false;
  bool _isLoading = false;
  final List<NoticeEntity> _all = [];

  Future<void> fetchNextPage() async {
    if (_isLoading || _isLastPage) return;
    _isLoading = true;

    print('fetchNextPage called: page=$_page, tab=$tab');

    try {
      final newItems = await useCase(
        page: _page,
        tab: tab,
        departmentType: departmentType,
      );

      print('Notice fetched: ${newItems.length} items');

      if (newItems.isEmpty) {
        _isLastPage = true;
      } else {
        _page++;
        _all.addAll(newItems);
        state = AsyncValue.data(_all);
      }
    } catch (e, st) {
      print('Error during fetch: $e');
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }
}
