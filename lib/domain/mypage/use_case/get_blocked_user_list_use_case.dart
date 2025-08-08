import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class GetBlockedUserListUseCase {
  final MypageRepository _mypageRepository;

  GetBlockedUserListUseCase(
    this._mypageRepository,
  );

  Future<List<BlockedUser>?> execute() async {
    final list = await _mypageRepository.getBlockedUserList();

    if (list == null || list.isEmpty) {
      return null;
    }

    return list;
  }
}