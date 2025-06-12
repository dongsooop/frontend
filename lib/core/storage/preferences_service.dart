import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _nicknameKey = 'nickname';
  static const _departmentKey = 'departmentType';

  static const _noticeCachedOnceKey = 'notice_cached_once';
  static const _noticeCachedTimeKey = 'notice_last_cached_time';

  Future<void> saveUser(User user) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_nicknameKey, user.nickname);
    await _prefs.setString(_departmentKey, user.departmentType);
  }

  Future<User?> getUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final nickname = _prefs.getString(_nicknameKey);
    final departmentType = _prefs.getString(_departmentKey);

    if (nickname != null && departmentType != null) {
      return User(nickname: nickname, departmentType: departmentType);
    }
    return null;
  }

  Future<void> clearUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(_nicknameKey);
    await _prefs.remove(_departmentKey);
  }

  // 마지막으로 공지 데이터 가져온 시간 불러오기
  Future<DateTime?> getNoticeCachedTime() async {
    final _prefs = await SharedPreferences.getInstance();
    final str = _prefs.getString(_noticeCachedTimeKey);
    return str != null ? DateTime.tryParse(str) : null;
  }

// 마지막으로 공지 데이터를 가져온 시간 저장
  Future<void> saveNoticeCachedTime(DateTime dateTime) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_noticeCachedTimeKey, dateTime.toIso8601String());
  }

// 공지를 한 번이라도 가져온 적 있는지 불러오기
  Future<bool> getNoticeHasCachedOnce() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_noticeCachedOnceKey) ?? false;
  }

// 공지를 한 번이라도 가져온 적 있는지 저장
  Future<void> saveNoticeHasCachedOnce(bool value) async {
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(_noticeCachedOnceKey, value);
  }
}

final preferencesProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
