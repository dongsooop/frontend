import 'package:dongsoop/data/device_token/model/device_token_request.dart';

abstract class DeviceTokenDataSource {
  Future<void> registerDeviceToken(DeviceTokenRequest request);
}
