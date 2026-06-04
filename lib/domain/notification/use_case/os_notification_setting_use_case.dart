import 'package:dongsoop/domain/notification/repository/os_notification_repository.dart';

class OsNotificationSettingsUseCase {
  final OsNotificationRepository repository;
  OsNotificationSettingsUseCase(this.repository);
  Future<void> execute() => repository.openOsSettings();
}