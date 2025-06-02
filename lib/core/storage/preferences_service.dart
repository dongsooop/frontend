import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dongsoop/domain/auth/model/user.dart';

class PreferencesService {
  static const _nicknameKey = 'nickname';
  static const _departmentKey = 'departmentType';

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
}

final preferencesProvider = Provider<PreferencesService>((ref) {
  return PreferencesService();
});