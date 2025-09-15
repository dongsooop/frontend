import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/notice/data_sources/notice_data_source.dart';
import 'package:dongsoop/data/notice/model/notice_model.dart';
import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final NoticeDataSource _remote;

  NoticeRepositoryImpl(this._remote);

  @override
  Future<List<NoticeEntity>> fetchSchoolNotices({
    required int page,
    bool force = false,
  }) async {
    return _handle(() async {
      final models = await _remote.fetchSchoolNotices(page: page);

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
      final models = await _remote.fetchDepartmentNotices(
        page: page,
        departmentType: departmentType,
      );

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
}

