import 'package:dongsoop/data/device_token/model/device_token_request.dart';

abstract class DeviceTokenRepository {
  Future<void> init();
  Future<String?> getFcmToken();
  Stream<String> tokenStreamWithInitial();
  Future<void> registerDeviceToken(DeviceTokenRequest request);
}
