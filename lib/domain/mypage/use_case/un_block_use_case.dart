import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class UnBlockUseCase {
  final MypageRepository _mypageRepository;

  UnBlockUseCase(
    this._mypageRepository,
  );

  Future<void> execute(int blockerId, int blockedMemberId) async {
    await _mypageRepository.unBlock(blockerId, blockedMemberId);
  }
}