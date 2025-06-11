import 'package:dongsoop/data/notice/data_sources/notice_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeLocalDataSourceImpl implements NoticeLocalDataSource {
  final SharedPreferences _prefs;
  NoticeLocalDataSourceImpl(this._prefs);

  // 마지막으로 공지 데이터 가져온 시간 확인
  @override
  Future<DateTime?> getLastCachedTime() async {
    final str = _prefs.getString('notice_last_cached_time');
    return str != null ? DateTime.tryParse(str) : null;
  }

  // 앱 실행 후 공지를 한 번이라도 가져온 적 있는지 확인
  @override
  Future<bool> getHasCachedOnce() async {
    return _prefs.getBool('notice_cached_once') ?? false;
  }

  // 마지막을 공지 데이터 가져온 시간 저장
  @override
  Future<void> saveCachedTime(DateTime dateTime) async {
    await _prefs.setString(
        'notice_last_cached_time', dateTime.toIso8601String());
  }

  // 앱 실행 후 공지를 한 번이라도 가져온 적 있는지 저장
  @override
  Future<void> saveHasCachedOnce(bool value) async {
    await _prefs.setBool('notice_cached_once', value);
  }
}
