import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

// FCM 토큰 초기 동기화
class FcmInitUseCase {
  final DeviceTokenRepository _deviceRepo;
  FcmInitUseCase(this._deviceRepo);

  Future<void> execute() => _deviceRepo.init();
}
