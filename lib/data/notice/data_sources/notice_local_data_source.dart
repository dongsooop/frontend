abstract class NoticeLocalDataSource {
  Future<DateTime?> getLastCachedTime();
  Future<bool> getHasCachedOnce();
  Future<void> saveCachedTime(DateTime dateTime);
  Future<void> saveHasCachedOnce(bool value);
}
