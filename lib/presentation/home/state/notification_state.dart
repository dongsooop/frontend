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
}