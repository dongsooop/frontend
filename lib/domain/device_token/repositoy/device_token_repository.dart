import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/domain/device_token/enum/failure_type.dart';

abstract class DeviceTokenRepository {
  Future<void> init();
  Future<String?> getFcmToken();
  Stream<String> tokenStreamWithInitial();
  Future<FailureType?> registerDeviceToken(DeviceTokenRequest request);
}
