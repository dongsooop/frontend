import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';
import 'package:dongsoop/domain/notification/repository/notification_repository.dart';

class NotificationListUseCase {
  final NotificationRepository _repo;
  NotificationListUseCase(this._repo);

  Future<NotificationResponseEntity> execute({
    required int page,
    int size = 10,
  }) {
    return _repo.fetchNotificationList(page: page, size: size);
  }

  Future<int> unreadOnly() async {
    final response = await _repo.fetchNotificationList(page: 0, size: 1);
    return response.unreadCount;
  }
}