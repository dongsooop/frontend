import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/network/error_handler_mixin.dart';
import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';
import 'package:dongsoop/domain/notice/reminder/repository/notice_reminder_repository.dart';

class NoticeReminderRepositoryImpl
    with ErrorHandlerMixin
    implements NoticeReminderRepository {
  final NoticeReminderDataSource _dataSource;

  NoticeReminderRepositoryImpl(this._dataSource);

  @override
  Future<void> setReminder({
    required int noticeId,
    required DateTime remindAt,
  }) {
    return _handle(
      () => _dataSource.setReminder(
        noticeId: noticeId,
        remindAt: remindAt,
      ),
    );
  }

  @override
  Future<void> deleteReminder({
    required int noticeId,
  }) {
    return _handle(
      () => _dataSource.deleteReminder(noticeId: noticeId),
    );
  }

  Future<T> _handle<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SessionExpiredException {
      rethrow;
    } catch (e, st) {
      final converted = convertError(e);
      if (converted is SessionExpiredException) {
        throw converted;
      }
      Error.throwWithStackTrace(NoticeReminderException(), st);
    }
  }
}
