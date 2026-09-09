import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fid_use_case.dart';

class NoticeReminderDataSourceImpl implements NoticeReminderDataSource {
  final Dio _plainDio;
  final GetFidUseCase _getFidUseCase;
  final GetFcmTokenUseCase _getFcmTokenUseCase;

  NoticeReminderDataSourceImpl(
    this._plainDio,
    this._getFidUseCase,
    this._getFcmTokenUseCase,
  );

  Future<Options> _deviceOptions() async {
    final fid = await _getFidUseCase.execute();
    final deviceToken = await _getFcmTokenUseCase.execute();

    if ((fid == null || fid.isEmpty) &&
        (deviceToken == null || deviceToken.isEmpty)) {
      throw Exception('device identifier is not ready');
    }

    return Options(
      headers: {
        if (fid != null && fid.isNotEmpty) 'X-Device-Fid': fid,
        if (deviceToken != null && deviceToken.isNotEmpty)
          'X-Device-Token': deviceToken,
      },
    );
  }

  @override
  Future<void> setReminder({
    required int noticeId,
    required DateTime remindAt,
  }) async {
    final response = await _plainDio.put(
      '/notice/$noticeId/reminder',
      data: {
        'remindAt': remindAt.toIso8601String(),
      },
      options: await _deviceOptions(),
    );

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteReminder({
    required int noticeId,
  }) async {
    final response = await _plainDio.delete(
      '/notice/$noticeId/reminder',
      options: await _deviceOptions(),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
