import 'package:dongsoop/domain/mypage/model/mypage_market.dart';

abstract class MypageDataSource {
  Future<List<MypageMarket>?> getPosts({int page = 0, int size = 10,});
}