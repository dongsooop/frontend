import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';
import 'package:dongsoop/domain/notice/reminder/repository/notice_reminder_repository.dart';

class NoticeReminderRepositoryImpl implements NoticeReminderRepository {
  final NoticeReminderDataSource _dataSource;

  NoticeReminderRepositoryImpl(this._dataSource);

  @override
  Future<void> upsert({
    required int noticeId,
    required DateTime remindAt,
  }) {
    return _dataSource.upsert(
      noticeId: noticeId,
      remindAt: remindAt,
    );
  }

  @override
  Future<void> delete({
    required int noticeId,
  }) {
    return _dataSource.delete(noticeId: noticeId);
  }
}
