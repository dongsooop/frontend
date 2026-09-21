import 'package:shared_preferences/shared_preferences.dart';

class EclassRelinkRefreshStore {
  EclassRelinkRefreshStore({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  static const _refreshRequiredKey = 'eclass_relink_refresh_required';

  final SharedPreferencesAsync _preferences;

  Future<void> markRefreshRequired() async {
    await _preferences.setBool(_refreshRequiredKey, true);
  }

  Future<bool> consumeRefreshRequired() async {
    final refreshRequired =
        await _preferences.getBool(_refreshRequiredKey) ?? false;
    if (!refreshRequired) return false;

    await _preferences.remove(_refreshRequiredKey);
    return true;
  }
}
