import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/notice/data_sources/notice_data_source.dart';
import 'package:dongsoop/data/notice/data_sources/notice_local_data_source.dart';
import 'package:dongsoop/data/notice/model/notice_model.dart';
import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeDataSource _remote;
  final NoticeLocalDataSource? _local;

  NoticeRepositoryImpl(this._remote, this._local);

  @override
  Future<List<NoticeEntity>> fetchSchoolNotices({
    required int page,
    bool force = false,
  }) async {
    return _handle(() async {
      final shouldFetch = await _shouldFetch(force);
      if (!shouldFetch) return [];

      final models = await _remote.fetchSchoolNotices(page: page);
      await _cache();

      return models
          .map((model) => model.toEntity(isDepartment: false))
          .toList();
    }, NoticeException());
  }

  @override
  Future<List<NoticeEntity>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
    bool force = false,
  }) async {
    return _handle(() async {
      final shouldFetch = await _shouldFetch(force);
      if (!shouldFetch) return [];

      final models = await _remote.fetchDepartmentNotices(
        page: page,
        departmentType: departmentType,
      );
      await _cache();

      return models.map((model) => model.toEntity(isDepartment: true)).toList();
    }, NoticeException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }

  Future<bool> _shouldFetch(bool force) async {
    if (force) return true;

    final hasCached = await _local?.getHasCachedOnce() ?? false;
    final lastCached = await _local?.getLastCachedTime();
    return !hasCached || _isExpired(lastCached);
  }

  Future<void> _cache() async {
    await _local?.saveCachedTime(DateTime.now());
    await _local?.saveHasCachedOnce(true);
  }

  bool _isExpired(DateTime? lastCachedTime) {
    final now = DateTime.now();
    final fetchTimes = [
      DateTime(now.year, now.month, now.day, 10, 10),
      DateTime(now.year, now.month, now.day, 14, 10),
      DateTime(now.year, now.month, now.day, 18, 10),
    ];

    for (final time in fetchTimes) {
      if (lastCachedTime == null && now.isAfter(time)) return true;
      if (lastCachedTime != null &&
          lastCachedTime.isBefore(time) &&
          now.isAfter(time)) return true;
    }
    return false;
  }
}
