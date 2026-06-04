import 'package:dongsoop/domain/notification/repository/notification_repository.dart';

class NotificationDeleteUseCase {
  final NotificationRepository _repo;

  NotificationDeleteUseCase(this._repo);

  Future<void> execute({
    required int id,
  }) async {
    return _repo.deleteNotification(
      id: id,
    );
  }
}