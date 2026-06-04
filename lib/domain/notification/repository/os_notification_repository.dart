abstract class OsNotificationRepository {
  Future<bool> isOsAllowed();
  Future<bool> requestPermission();
  Future<void> openOsSettings();
}