import 'package:dongsoop/domain/mypage/model/social_state.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class GetSocialStateUseCase {
  final MypageRepository _mypageRepository;

  GetSocialStateUseCase(this._mypageRepository,);

  Future<List<SocialState>?> execute() async {
    final list = await _mypageRepository.getSocialStateList();

    if (list == null || list.isEmpty) {
      return null;
    }

    return list;
  }
}