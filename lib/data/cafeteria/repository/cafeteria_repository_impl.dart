import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_data_source.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_local_data_source.dart';
import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:dongsoop/data/cafeteria/model/meal_price_response.dart';
import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:dongsoop/domain/cafeteria/repository/cafeteria_repository.dart';

class CafeteriaRepositoryImpl implements CafeteriaRepository {
  final CafeteriaDataSource _remote;
  final CafeteriaLocalDataSource _local;

  CafeteriaRepositoryImpl(this._remote, this._local);

  @override
  Future<CafeteriaEntity> fetchCafeteriaMeals() async {
    try {
      final cached = await _local.getCachedCafeteria();

      final shouldRefresh = _shouldRefreshCache(cached);

      if (!shouldRefresh) {
        return cached!.toEntity();
      }

      final response = await _remote.fetchCafeteriaMeals();

      await _local.cacheCafeteria(response);

      return response.toEntity();
    } catch (e) {
      throw CafeteriaException();
    }
  }

  @override
  Future<CafeteriaEntity?> getCachedCafeteriaMeals() async {
    final cached = await _local.getCachedCafeteria();
    return cached?.toEntity();
  }

  /// 가격표는 캐시하지 않는다. 서버가 하루치 캐시 헤더를 붙여 내려주고,
  /// 설정 파일 값이라 주간 식단처럼 날짜로 만료를 따질 것도 없다.
  @override
  Future<MealPriceEntity> fetchMealPrices() async {
    final response = await _remote.fetchMealPrices();
    return response.toEntity();
  }

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
