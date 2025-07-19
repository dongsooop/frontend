import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class MypageRepositoryImpl implements MypageRepository {
  final MypageDataSource _mypageDataSource;

  MypageRepositoryImpl(
    this._mypageDataSource,
  );

  @override
  Future<List<MypageMarket>?> getMargetPosts({int page = 0, int size = 10})  async {
    final posts = await _mypageDataSource.getMarketPosts(page: page, size: size);
    if (posts == null || posts.isEmpty) return [];

    return posts;
  }
  @override
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10})  async {
    final posts = await _mypageDataSource.getRecruitPosts(isApply, page: page, size: size);
    if (posts == null || posts.isEmpty) return [];

    return posts;
  }
}