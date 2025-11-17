import 'package:dongsoop/domain/notification/repository/os_notification_repository.dart';

class OsNotificationPermissionUseCase {
  final OsNotificationRepository repository;
  OsNotificationPermissionUseCase(this.repository);
  Future<bool> execute() => repository.requestPermission();
}