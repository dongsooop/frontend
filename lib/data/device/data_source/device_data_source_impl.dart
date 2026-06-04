import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/device/data_source/device_data_source.dart';
import 'package:dongsoop/data/device/model/device_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeviceDataSourceImpl implements DeviceDataSource {
  final Dio _authDio;
  final SecureStorageService _secureStorageService;

  DeviceDataSourceImpl(
      this._authDio,
      this._secureStorageService,
      );

  @override
  Future<List<DeviceResponse>> getDeviceList() async {
    final url = dotenv.get('DEVICE_LIST_ENDPOINT');
    final deviceToken = await _secureStorageService.read('fcmToken');

    try {
      final response = await _authDio.get(
        url,
        options: Options(
          headers: {
            if (deviceToken != null) 'x-device-token': deviceToken,
          },
        ),
      );

      if (response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }

      final List<dynamic> raw = response.data;

      return raw
          .map((e) => DeviceResponse.fromJson(
        Map<String, dynamic>.from(e),
      ))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> forceLogout(int deviceId) async {
    final baseEndpoint = dotenv.get('DEVICE_REGISTRATION_ENDPOINT');
    final endpoint = '$baseEndpoint/$deviceId';

    try {
      final response = await _authDio.delete(endpoint);

      if (response.statusCode != HttpStatusCode.noContent.code &&
          response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}