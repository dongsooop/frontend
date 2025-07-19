import '../model/mypage_market.dart';

abstract class MypageRepository {
  Future<List<MypageMarket>?> getMargetPosts({int page = 0, int size = 10,});
}