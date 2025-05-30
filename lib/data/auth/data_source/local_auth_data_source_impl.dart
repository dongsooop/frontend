import 'package:dongsoop/data/auth/data_source/local_auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  static const _nicknameKey = 'nickname';
  static const _departmentKey = 'departmentType';

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nicknameKey, user.nickname);
    await prefs.setString(_departmentKey, user.departmentType);
  }

  @override
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nickname = prefs.getString(_nicknameKey);
    final departmentType = prefs.getString(_departmentKey);

    if (nickname != null && departmentType != null) {
      return User(nickname: nickname, departmentType: departmentType);
    }

    return null;
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nicknameKey);
    await prefs.remove(_departmentKey);
  }
}