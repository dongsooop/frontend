import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/presentation/home/providers/notice_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notice_list_view_model.g.dart';

enum NoticeTab { all, school, department }

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

@riverpod
class NoticeListViewModel extends _$NoticeListViewModel {
  int _page = 0;
  bool _isLastPage = false;
  bool _isLoading = false;
  final List<NoticeEntity> _items = [];

  bool get isLastPage => _isLastPage;

  @override
  Future<List<NoticeEntity>> build(NoticeListArgs args) async {
    _page = 0;
    _isLastPage = false;
    _items.clear();
    return await _fetchNext(args);
  }

  Future<void> fetchNextPage(NoticeListArgs args) async {
    if (_isLoading || _isLastPage) return;
    _isLoading = true;

    try {
      final nextItems = await _fetch(args, page: _page);
      if (nextItems.isEmpty) {
        _isLastPage = true;
      } else {
        _page++;
        _items.addAll(nextItems);
        state = AsyncValue.data([..._items]);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoading = false;
    }
  }

  Future<List<NoticeEntity>> _fetchNext(NoticeListArgs args) async {
    try {
      final items = await _fetch(args, page: _page);
      if (items.isEmpty) {
        _isLastPage = true;
      } else {
        _page++;
        _items.addAll(items);
      }
      return [..._items];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NoticeEntity>> _fetch(NoticeListArgs args,
      {required int page}) async {
    switch (args.tab) {
      case NoticeTab.school:
        final useCase = ref.read(NoticeSchoolUseCaseProvider);
        return await useCase.execute(page: page);

      case NoticeTab.department:
        if (args.departmentType == null) return [];
        final useCase = ref.read(NoticeDepartmentUseCaseProvider);
        return await useCase.execute(
          page: page,
          departmentType: args.departmentType!,
        );

      case NoticeTab.all:
        final useCase = await ref.read(NoticeCombinedUseCaseProvider.future);
        return await useCase.execute(
          page: page,
          departmentType: args.departmentType,
        );
    }
  }
}
