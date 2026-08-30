import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

// Firebase Installation ID(FID) 1회 조회 — 실패 시 null
class GetFidUseCase {
  final DeviceTokenRepository _deviceRepo;
  GetFidUseCase(this._deviceRepo);

  Future<String?> execute() => _deviceRepo.getFid();
}
