import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notification/data_source/notification_data_source.dart';
import 'package:dongsoop/data/notification/model/notification_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationDataSourceImpl implements NotificationDataSource {
  final Dio _authDio;
  NotificationDataSourceImpl(this._authDio);

  @override
  Future<NotificationResponseModel> fetchNotificationList({
    required int page,
    required int size,
  }) async {
    final url = dotenv.get('NOTIFICATION_ENDPOINT');
    final query = <String, dynamic>{
      'page': page,
      'size': size,
      'sort': ['id,desc'],
    };

    final response = await _authDio.get(url, queryParameters: query);

    if (kDebugMode) {
      debugPrint('[NotificationDS] GET $url query=$query');
      debugPrint('[NotificationDS] <- ${response.statusCode} (type=${response.data.runtimeType})');
    }

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('응답 형식이 Map이 아닙니다.');
      }
      return NotificationResponseModel.fromJson(data);
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> readNotification({required int id}) async {
    final url = dotenv.get('NOTIFICATION_READ_ENDPOINT');
    final response = await _authDio.post(url, data: {'id': id});
    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteNotification({required int id}) async {
    final baseUrl = dotenv.get('NOTIFICATION_ENDPOINT');
    final url = '$baseUrl/$id';
    final response = await _authDio.delete(url);
    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
