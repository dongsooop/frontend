import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _idKey = 'id';
  static const _nicknameKey = 'nickname';
  static const _departmentKey = 'departmentType';
  static const _roleKey = 'role';
  static const _notificationPermissionRequestedKey = 'notification_permission_requested';

  Future<void> saveUser(User user) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt(_idKey, user.id);
    await _prefs.setString(_nicknameKey, user.nickname);
    await _prefs.setString(_departmentKey, user.departmentType);
    await _prefs.setStringList(_roleKey, user.role);
  }

  Future<User?> getUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final id = _prefs.getInt(_idKey);
    final nickname = _prefs.getString(_nicknameKey);
    final departmentType = _prefs.getString(_departmentKey);
    final role = _prefs.getStringList(_roleKey);

    if (id != null && nickname != null && departmentType != null && role != null) {
      return User(id: id, nickname: nickname, departmentType: departmentType, role: role);
    }
    return null;
  }

  Future<void> clearUser() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(_idKey);
    await _prefs.remove(_nicknameKey);
    await _prefs.remove(_departmentKey);
  }

  Future<bool> isNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationPermissionRequestedKey) ?? false;
  }

  Future<void> setNotificationPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPermissionRequestedKey, true);
  }
}

final preferencesProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});
