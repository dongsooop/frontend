import 'package:dongsoop/domain/fcm_token/repository/fcm_token_repository.dart';

class FcmTokenUseCase {
  final FcmTokenRepository _repository;

  FcmTokenUseCase(this._repository);

  Future<String?> execute() {
    return _repository.getFcmToken();
  }
}
