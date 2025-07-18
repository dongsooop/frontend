import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import '../repository/mypage_repository.dart';

class GetMyMarketPostsUseCase {
  final MypageRepository _mypageRepository;

  GetMyMarketPostsUseCase(
    this._mypageRepository,
  );

  Future<List<MypageMarket>?> execute({
      int page = 0,
      int size = 10,
    }) async {

    final posts = await _mypageRepository.getMargetPosts(
      page: page,
      size: size,
    );

    if (posts == null || posts.isEmpty) {
      return null;
    }

    return posts;
  }
}