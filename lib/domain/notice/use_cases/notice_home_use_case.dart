import 'package:dongsoop/data/notice/data_sources/notice_local_data_source.dart';
import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';
import 'package:dongsoop/main.dart';

class NoticeHomeUseCase {
  final NoticeRepository _repository;
  final NoticeLocalDataSource _localDataSource;

  NoticeHomeUseCase(this._repository, this._localDataSource);

  Future<List<NoticeEntity>> execute({
    required int page,
    required String? departmentType,
    bool force = false,
  }) async {
    logger.i('[UseCase] 실행됨 | force: $force');

    final hasCachedOnce = await _localDataSource.getHasCachedOnce();
    final lastCachedTime = await _localDataSource.getLastCachedTime();

    final shouldFetch =
        force || !hasCachedOnce || _isNeedToFetch(lastCachedTime);

    logger.i('📦 [Cache] hasCachedOnce: $hasCachedOnce');
    logger.i('📦 [Cache] lastCachedTime: $lastCachedTime');
    logger.i('🔍 [Decision] shouldFetch: $shouldFetch');

    if (!shouldFetch) {
      logger.i('[Skip] 캐시 유효. fetch 생략');
      return [];
    }

    final notices = await _fetchNotices(
      page: page,
      departmentType: departmentType,
      force: true,
    );

    logger.i('[Result] 받아온 공지 개수: ${notices.length}');

    await _localDataSource.saveCachedTime(DateTime.now());
    await _localDataSource.saveHasCachedOnce(true);

    return notices;
  }

  Future<List<NoticeEntity>> _fetchNotices({
    required int page,
    required String? departmentType,
    required bool force,
  }) async {
    if (departmentType == null) {
      print('[Fetch] 학교 공지 요청');
      return await _repository.fetchSchoolNotices(page: page, force: force);
    } else {
      print('[Fetch] 학교 + 학과 공지 요청');
      final schoolNotices =
          await _repository.fetchSchoolNotices(page: page, force: force);
      final departmentNotices = await _repository.fetchDepartmentNotices(
        page: page,
        departmentType: departmentType,
        force: force,
      );

      final all = [...schoolNotices, ...departmentNotices]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순 정렬
      return all;
    }
  }
}

bool _isNeedToFetch(DateTime? lastCachedTime) {
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
