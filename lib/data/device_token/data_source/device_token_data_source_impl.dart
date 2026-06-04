import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeviceTokenDataSourceImpl implements DeviceTokenDataSource {
  DeviceTokenDataSourceImpl(this._plainDio, this._storage);
  final Dio _plainDio;
  final SecureStorageService _storage;
  static const fcmLastToken = 'fcmLastToken';

  @override
  Future<void> registerDeviceToken(DeviceTokenRequest request) async {
    final currentToken = request.deviceToken;
    if (currentToken.isEmpty) {
      return;
    }
    final fcmLastToken = await _storage.read(SecureStorageService.fcmLastToken);
    if (fcmLastToken != null && fcmLastToken == currentToken) {
      return;
    }

    final endpoint = dotenv.get('DEVICE_REGISTRATION_ENDPOINT');
    final requestBody = request.toJson();
    try {
      final response = await _plainDio.post(endpoint, data: requestBody);

      if (response.statusCode == HttpStatusCode.noContent.code) {
        await _storage.write(SecureStorageService.fcmLastToken, currentToken);
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
