import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import '../repository/mypage_repository.dart';

class GetMyRecruitPostsUseCase {
  final MypageRepository _mypageRepository;

  GetMyRecruitPostsUseCase(
    this._mypageRepository,
  );

  Future<List<MypageRecruit>?> execute({
    required bool isApply,
    int page = 0,
    int size = 10,
  }) async {

    final posts = await _mypageRepository.getRecruitPosts(
      isApply,
      page: page,
      size: size,
    );

    if (posts == null || posts.isEmpty) {
      return null;
    }

    return posts;
  }
}