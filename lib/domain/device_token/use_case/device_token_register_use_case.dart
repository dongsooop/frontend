import 'package:dongsoop/data/device_token/model/device_token_request.dart';
import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

// 서버에 디바이스 토큰 등록
class DeviceRegisterTokenUseCase {
  final DeviceTokenRepository _deviceRepo;
  DeviceRegisterTokenUseCase(this._deviceRepo);

  Future<void> execute(DeviceTokenRequest request) {
    return _deviceRepo.registerDeviceToken(request);
  }
}
