import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';

class NoticeReminderDataSourceImpl implements NoticeReminderDataSource {
  final Dio _authDio;

  NoticeReminderDataSourceImpl(this._authDio);

  @override
  Future<void> setReminder({
    required int noticeId,
    required DateTime remindAt,
  }) async {
    final response = await _authDio.put(
      '/notice/$noticeId/reminder',
      data: {
        'remindAt': remindAt.toIso8601String(),
      },
    );

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteReminder({
    required int noticeId,
  }) async {
    final response = await _authDio.delete('/notice/$noticeId/reminder');

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
