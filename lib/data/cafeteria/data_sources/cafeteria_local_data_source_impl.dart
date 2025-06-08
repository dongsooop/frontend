import 'dart:convert';

import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cafeteria_local_data_source.dart';

class CafeteriaLocalDataSourceImpl implements CafeteriaLocalDataSource {
  static const _cafeteriaKey = 'cafeteria_data';

  @override
  Future<void> cacheCafeteria(CafeteriaResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_cafeteriaKey, jsonEncode(response.toJson()));
  }

  @override
  Future<CafeteriaResponse?> getCachedCafeteria() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cafeteriaKey);

    if (json == null) {
      print('📦 [SharedPreferences] 캐시 없음');
      return null;
    }

    print('📦 [SharedPreferences] 캐시된 JSON:\n$json');
    final decoded = jsonDecode(json);
    return CafeteriaResponse.fromJson(decoded);
  }

  @override
  Future<void> clearCacheCafeteria() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cafeteriaKey);
  }
}
