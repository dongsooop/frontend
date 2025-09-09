import 'package:dongsoop/domain/notification/repository/notification_repository.dart';

class NotificationReadAllUseCase {
  final NotificationRepository _repo;

  NotificationReadAllUseCase(this._repo);

  Future<void> execute()
    async {
      return _repo.readAllNotification();
    }
  }