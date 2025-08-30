import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dongsoop/domain/notification/use_case/notification_delete_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_list_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_read_use_case.dart';

import 'package:dongsoop/domain/notification/entity/notification_entity.dart';
import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';

import 'package:dongsoop/presentation/home/state/notification_state.dart';
import 'package:dongsoop/presentation/home/providers/notification_use_case_provider.dart';

part 'notification_view_model.g.dart';

@riverpod
class NotificationViewModel extends _$NotificationViewModel {
  static const int _pageSize = 10;

  NotificationListUseCase   get _listUseCase   => ref.read(notificationUseCaseProvider);
  NotificationReadUseCase   get _readUseCase   => ref.read(notificationReadUseCaseProvider);
  NotificationDeleteUseCase get _deleteUseCase => ref.read(notificationDeleteUseCaseProvider);

  bool _initialized = false;

  @override
  NotificationState build() {
    state = const NotificationState();
    Future.microtask(_initialize);
    return state;
  }

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final NotificationResponseEntity page =
      await _listUseCase.execute(page: state.page, size: _pageSize);

      final seen = state.items.map((e) => e.id).toSet();
      final List<NotificationEntity> fresh = [];
      for (final n in page.items) {
        if (seen.add(n.id)) fresh.add(n);
      }

      state = state.copyWith(
        items: [...state.items, ...fresh],
        page: state.page + 1,
        hasMore: page.items.length == _pageSize,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    _initialized = false;
    state = const NotificationState();
    await _initialize();
  }

  Future<void> read(int id) async {
    if (id <= 0) return;

    try {
      await _readUseCase.execute(id: id);
      state = state.read(id);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> delete(int id) async {
    try {
      await _deleteUseCase.execute(id: id);
      state = state.removeById(id);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
