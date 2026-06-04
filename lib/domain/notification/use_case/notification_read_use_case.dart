import 'package:dongsoop/domain/notification/repository/notification_repository.dart';

class NotificationReadUseCase {
  final NotificationRepository _repo;

  NotificationReadUseCase(this._repo);

  Future<void> execute({
    required int id,
  }) async {
    return _repo.readNotification(
      id: id,
    );
  }
}