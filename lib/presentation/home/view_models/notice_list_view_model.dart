import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/presentation/home/providers/notice_use_case_provider.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/subscribe_department_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/core/exception/exception.dart';

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
    try {
      return await _fetchNext(args);
    } on SessionExpiredException {
      throw const SessionExpiredException();
    } catch (e) {
      rethrow;
    }
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
    } on SessionExpiredException {
      state = AsyncValue.error(const SessionExpiredException(), StackTrace.current);
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
    try {
      switch (args.tab) {
        case NoticeTab.school:
          final useCase = ref.read(NoticeSchoolUseCaseProvider);
          return await useCase.execute(page: page);

        case NoticeTab.department:
          // 회원/비회원 구분 없이 디바이스가 구독한 학과 기준으로 조회한다.
          final fid = await ref.read(getFidUseCaseProvider).execute();
          final deviceToken = await ref.read(getFcmTokenUseCaseProvider).execute();

          if (page == 0) {
            // 구독한 학과가 없으면 목록 대신 학과 선택 화면으로 보낸다.
            final subscribed = await ref
                .read(getSubscribeDepartmentsUseCaseProvider)
                .execute(fid: fid, deviceToken: deviceToken ?? '');
            if (subscribed.isEmpty) {
              throw NoSubscribedDepartmentsException();
            }
          }

          final useCase = ref.read(NoticeSubscribedUseCaseProvider);
          return await useCase.execute(
            page: page,
            fid: fid,
            deviceToken: deviceToken,
          );

        case NoticeTab.all:
          final useCase = await ref.read(NoticeCombinedUseCaseProvider.future);
          return await useCase.execute(
            page: page,
            departmentType: args.departmentType,
          );
      }
    } on SessionExpiredException {
      throw const SessionExpiredException();
    } catch (e) {
      rethrow;
    }
  }
}