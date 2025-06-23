import 'dart:convert';

import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cafeteria_local_data_source.dart';

class CafeteriaLocalDataSourceImpl implements CafeteriaLocalDataSource {
  static const _cafeteriaKey = 'cafeteria_data';

  @override
  Future<void> cacheCafeteria(CafeteriaResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(response.toJson());

    print('💾 [SharedPreferences] 저장 시도: $encoded');

    // 검증
    final verify = prefs.getString(_cafeteriaKey);
    print('📦 저장된 최종 캐시:\n$verify');
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
    print('🧹 [SharedPreferences] 캐시 삭제 완료');
  }
}
