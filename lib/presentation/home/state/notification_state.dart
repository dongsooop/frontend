import 'package:dongsoop/domain/notification/entity/notification_entity.dart';

class NotificationState {
  final List<NotificationEntity> items;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationEntity>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  NotificationState read(int id) {
    final updated = items.map((e) {
      if (e.id != id || e.isRead) return e;
      return NotificationEntity(
        id: e.id,
        title: e.title,
        body: e.body,
        type: e.type,
        value: e.value,
        isRead: true,
        createdAt: e.createdAt,
      );
    }).toList();

    return copyWith(items: updated, error: null);
  }

  NotificationState readAll() {
    if (allRead) return copyWith(error: null);

    final updated = items.map((e) {
      if (e.isRead) return e;
      return NotificationEntity(
        id: e.id,
        title: e.title,
        body: e.body,
        type: e.type,
        value: e.value,
        isRead: true,
        createdAt: e.createdAt,
      );
    }).toList();

    return copyWith(items: updated, error: null);
  }

  NotificationState removeById(int id) =>
      copyWith(items: items.where((e) => e.id != id).toList(), error: null);

  int get unreadCount => items.where((e) => !e.isRead).length;
  bool get allRead => items.every((e) => e.isRead);
}
