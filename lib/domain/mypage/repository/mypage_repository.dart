import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import '../model/mypage_market.dart';

abstract class MypageRepository {
  Future<List<MypageMarket>?> getMargetPosts({int page = 0, int size = 10,});
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,});
}