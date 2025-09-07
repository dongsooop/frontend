import 'package:dongsoop/domain/notification/use_case/notification_read_all_use_case.dart';
import 'package:dongsoop/presentation/home/providers/notification_use_case_provider.dart';
import 'package:dongsoop/presentation/home/state/notification_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/domain/notification/use_case/notification_delete_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_list_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_read_use_case.dart';
import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';

part 'notification_view_model.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  static const int _pageSize = 10;

  NotificationListUseCase get _listUseCase => ref.read(notificationUseCaseProvider);
  NotificationReadUseCase get _readUseCase => ref.read(notificationReadUseCaseProvider);
  NotificationReadAllUseCase get _readAllUseCase => ref.read(notificationReadAllUseCaseProvider);
  NotificationDeleteUseCase get _deleteUseCase => ref.read(notificationDeleteUseCaseProvider);

  @override
  Future<NotificationState> build() async {
    return _loadNextPageInternal(
      const NotificationState(),
    );
  }

  Future<NotificationState> _loadNextPageInternal(
      NotificationState current) async {
    if (!current.hasMore) return current;

    final NotificationResponseEntity page =
    await _listUseCase.execute(page: current.page, size: _pageSize);

    final seen = current.items.map((e) => e.id).toSet();
    final fresh = page.items.where((n) => seen.add(n.id)).toList();

    return current.copyWith(
      items: [...current.items, ...fresh],
      page: current.page + 1,
      hasMore: page.items.length == _pageSize,
      isLoading: false,
      error: null,
    );
  }

  Future<void> loadNextPage() async {
    state = const AsyncLoading<NotificationState>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      final current = state.value ?? const NotificationState();
      return _loadNextPageInternal(current);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return _loadNextPageInternal(const NotificationState());
    });
  }

  Future<void> read(int id) async {
    if (id <= 0) return;
    await _readUseCase.execute(id: id);
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.read(id));
  }

  Future<void> readAll() async {
    await _readAllUseCase.execute();
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.readAll());
  }

  Future<void> delete(int id) async {
    await _deleteUseCase.execute(id: id);
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.removeById(id));
  }
}
