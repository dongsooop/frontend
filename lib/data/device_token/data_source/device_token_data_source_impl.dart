import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/device_token/data_source/device_token_data_source.dart';
import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeviceTokenDataSourceImpl implements DeviceTokenDataSource {
  DeviceTokenDataSourceImpl(this._plainDio);
  final Dio _plainDio;

  @override
  Future<void> registerDeviceToken(DeviceTokenRequest request) async {
    final endpoint = dotenv.get('DEVICE_REGISTRATION_ENDPOINT');
    final requestBody = request.toJson();

    final response = await _plainDio.post(endpoint, data: requestBody);

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
