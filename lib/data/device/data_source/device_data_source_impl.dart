import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/device/data_source/device_data_source.dart';
import 'package:dongsoop/data/device/model/device_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeviceDataSourceImpl implements DeviceDataSource {
  final Dio _authDio;

  DeviceDataSourceImpl(this._authDio);

  @override
  Future<List<DeviceResponse>> getDeviceList() async {
    final url = dotenv.get('DEVICE_LIST_ENDPOINT');
    try {
      final response = await _authDio.get(url);

      if (response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }

      final List<dynamic> raw = response.data;

      return raw
          .map((e) => DeviceResponse.fromJson(
        Map<String, dynamic>.from(e),
      ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forceLogout(int deviceId) async {
    try {
      final response = await _authDio.delete('/$deviceId');

      if (response.statusCode != HttpStatusCode.noContent.code &&
          response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}