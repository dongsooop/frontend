import 'package:dio/dio.dart';
import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';

class NoticeReminderDataSourceImpl implements NoticeReminderDataSource {
  final Dio _authDio;

  NoticeReminderDataSourceImpl(this._authDio);

  @override
  Future<void> upsert({
    required int noticeId,
    required DateTime remindAt,
  }) async {
    await _authDio.put(
      '/notice/$noticeId/reminder',
      data: {
        'remindAt': remindAt.toIso8601String(),
      },
    );
  }

  @override
  Future<void> delete({
    required int noticeId,
  }) async {
    await _authDio.delete('/notice/$noticeId/reminder');
  }
}
