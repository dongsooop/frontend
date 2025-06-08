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

      if (!_shouldRefreshCache(cached)) {
        return cached!.toEntity();
      }

      final response = await _remote.fetchCafeteriaMeals();
      await _local.cacheCafeteria(response);
      return response.toEntity();
    } catch (_) {
      throw CafeteriaException();
    }
  }

  @override
  Future<CafeteriaEntity?> getCachedCafeteriaMeals() async {
    final cached = await _local.getCachedCafeteria();
    return cached?.toEntity();
  }

  bool _shouldRefreshCache(CafeteriaResponse? cached) {
    if (cached == null) return true;

    final now = DateTime.now();
    final start = DateTime.tryParse(cached.startDate);
    final end = DateTime.tryParse(cached.endDate);

    if (start == null || end == null) return true;

    return now.isBefore(start) || now.isAfter(end);
  }
}
