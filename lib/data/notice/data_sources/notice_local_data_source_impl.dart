import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/data/notice/data_sources/notice_local_data_source.dart';

class NoticeLocalDataSourceImpl implements NoticeLocalDataSource {
  final PreferencesService _prefs;

  NoticeLocalDataSourceImpl(this._prefs);

  @override
  Future<DateTime?> getLastCachedTime() => _prefs.getNoticeCachedTime();

  @override
  Future<bool> getHasCachedOnce() => _prefs.getNoticeHasCachedOnce();

  @override
  Future<void> saveCachedTime(DateTime dateTime) =>
      _prefs.saveNoticeCachedTime(dateTime);

  @override
  Future<void> saveHasCachedOnce(bool value) =>
      _prefs.saveNoticeHasCachedOnce(value);
}
