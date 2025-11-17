import 'package:dongsoop/domain/notification/repository/os_notification_repository.dart';
import 'package:dongsoop/data/notification/data_source/os_notification_data_source.dart';

class OsNotificationRepositoryImpl implements OsNotificationRepository {
  final OsNotificationDataSource dataSource;
  OsNotificationRepositoryImpl(this.dataSource);

  @override
  Future<bool> isOsAllowed() => dataSource.isAllowed();

  @override
  Future<bool> requestPermission() => dataSource.request();

  @override
  Future<void> openOsSettings() => dataSource.openSettings();
}