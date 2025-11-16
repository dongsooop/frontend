import 'package:dongsoop/domain/notification/repository/os_notification_repository.dart';

class OsNotificationAllowUseCase {
  final OsNotificationRepository repository;
  OsNotificationAllowUseCase(this.repository);
  Future<bool> execute() => repository.isOsAllowed();
}