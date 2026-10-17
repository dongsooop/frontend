import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class BlindDateResetUseCase {
  final MypageRepository _mypageRepository;

  BlindDateResetUseCase(this._mypageRepository);

  Future<void> execute() async {
    await _mypageRepository.resetBlindDateParticipants();
  }
}
