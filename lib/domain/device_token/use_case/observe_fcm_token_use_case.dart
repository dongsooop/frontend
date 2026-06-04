import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

class ObserveFcmTokenUseCase {
  final DeviceTokenRepository _deviceRepo;
  ObserveFcmTokenUseCase(this._deviceRepo);

  Stream<String> execute() => _deviceRepo.tokenStreamWithInitial();
}
