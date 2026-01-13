import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notification/model/notification_enable_model.dart';
import 'package:dongsoop/data/notification/model/notification_recruit_model.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'notification_setting_data_source.dart';

class NotificationSettingDataSourceImpl implements NotificationSettingDataSource {
  final Dio _authDio;
  final Dio _plainDio;

  NotificationSettingDataSourceImpl(this._authDio, this._plainDio);

  Dio _dio(NotificationTarget target) =>
      target == NotificationTarget.user ? _authDio : _plainDio;

  @override
  Future<Map<String, dynamic>> fetchSettings({
    required NotificationTarget target,
    required String deviceToken,
  }) async {
    final url = dotenv.get('NOTIFICATION_FIND');

    final response = await _dio(target).post(
      url,
      data: {'deviceToken': deviceToken},
    );

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception(
        'Notification FETCH_SETTINGS failed. status: ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Notification FETCH_SETTINGS invalid response type: ${data.runtimeType}',
      );
    }

    return data;
  }

  @override
  Future<void> enable({
    required NotificationTarget target,
    required NotificationEnableModel body,
  }) async {
    final url = dotenv.get('NOTIFICATION_ENABLE');

    final response = await _dio(target).post(
      url,
      data: body.toJson(),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'Notification ENABLE failed. status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> disable({
    required NotificationTarget target,
    required NotificationEnableModel body,
  }) async {
    final url = dotenv.get('NOTIFICATION_DISABLE');

    final response = await _dio(target).post(
      url,
      data: body.toJson(),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'Notification DISABLE failed. status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> setApply({
    required NotificationTarget target,
    required NotificationRecruitModel body,
  }) async {
    final url = dotenv.get('NOTIFICATION_APPLY');

    final response = await _dio(target).post(
      url,
      data: body.toJson(),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'Notification APPLY failed. status: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> setResult({
    required NotificationTarget target,
    required NotificationRecruitModel body,
  }) async {
    final url = dotenv.get('NOTIFICATION_RESULT');

    final response = await _dio(target).post(
      url,
      data: body.toJson(),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'Notification RESULT failed. status: ${response.statusCode}',
      );
    }
  }
}