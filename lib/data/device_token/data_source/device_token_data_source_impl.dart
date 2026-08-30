import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeviceTokenDataSourceImpl implements DeviceTokenDataSource {
  DeviceTokenDataSourceImpl(this._dio, this._storage);
  final Dio _dio;
  final SecureStorageService _storage;
  static const fcmLastToken = 'fcmLastToken';

  @override
  Future<void> registerDeviceToken(DeviceTokenRequest request) async {
    final currentToken = request.deviceToken;
    if (currentToken.isEmpty) {
      return;
    }

    final lastToken = await _storage.read(SecureStorageService.fcmLastToken);
    final lastFid = await _storage.read(SecureStorageService.fcmLastFid);
    final tokenUnchanged = lastToken != null && lastToken == currentToken;
    // fid가 아직 이 기기에서 한 번도 보고되지 않았으면(fid는 있는데 lastFid가 없거나 다르면),
    // 토큰이 그대로여도 서버 호출을 스킵하지 않는다 — 그래야 오래만에 앱을 켠 기존 사용자도
    // 백필된다.
    final fidAlreadyReported =
        request.fid == null || (lastFid != null && lastFid == request.fid);
    if (tokenUnchanged && fidAlreadyReported) {
      return;
    }

    final endpoint = dotenv.get('DEVICE_REGISTRATION_ENDPOINT');
    final requestBody = request.toJson();
    try {
      final response = await _dio.post(endpoint, data: requestBody);

      if (response.statusCode == HttpStatusCode.created.code) {
        await _storage.write(SecureStorageService.fcmLastToken, currentToken);
        if (request.fid != null) {
          await _storage.write(SecureStorageService.fcmLastFid, request.fid!);
        }
        return;
      }

      throw Exception('status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        await _storage.write(SecureStorageService.fcmLastToken, currentToken);
        return;
      }
      rethrow;
    }
  }
}
