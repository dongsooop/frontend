import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_data_source.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_local_data_source.dart';
import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/repository/cafeteria_repository.dart';

class CafeteriaRepositoryImpl implements CafeteriaRepository {
  final CafeteriaDataSource _remote;
  final CafeteriaLocalDataSource _local;

  CafeteriaRepositoryImpl(this._remote, this._local);

  @override
  Future<CafeteriaEntity> fetchCafeteriaMeals() async {
    try {
      final cached = await _local.getCachedCafeteria();

      print('🔥 캐시 확인됨? ${cached != null}');
      final shouldRefresh = _shouldRefreshCache(cached);
      print('🔥 shouldRefreshCache = $shouldRefresh');

      if (!shouldRefresh) {
        print('📦 캐시 사용함');
        return cached!.toEntity();
      }

      print('🌐 서버 요청 보냄');
      final response = await _remote.fetchCafeteriaMeals();

      print('💾 서버 응답 도착, 캐시 저장 시도');
      await _local.cacheCafeteria(response);

      return response.toEntity();
    } catch (e, stack) {
      print('❌ 예외 발생: $e');
      print(stack);
      throw CafeteriaException();
    }
  }

  @override
  Future<CafeteriaEntity?> getCachedCafeteriaMeals() async {
    final cached = await _local.getCachedCafeteria();
    return cached?.toEntity();
  }

  /// 🔽 오늘 날짜가 캐시된 주차 범위 안에 있는지 확인 (날짜만 비교)
  bool _shouldRefreshCache(CafeteriaResponse? cached) {
    if (cached == null) return true;

    final today = _dateOnly(DateTime.now());
    final start = _tryParseDateOnly(cached.startDate);
    final end = _tryParseDateOnly(cached.endDate);

    if (start == null || end == null) return true;

    final isCacheExpired = today.isBefore(start) || today.isAfter(end);
    final shouldRefresh = isCacheExpired;

    return shouldRefresh;
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime? _tryParseDateOnly(String input) {
    try {
      final parsed = DateTime.parse(input);
      return _dateOnly(parsed);
    } catch (_) {
      return null;
    }
  }
}
