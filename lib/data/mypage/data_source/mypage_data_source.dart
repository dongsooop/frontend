import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';

abstract class MypageDataSource {
  Future<List<MypageMarket>?> getMarketPosts({int page = 0, int size = 10,});
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,});
  Future<void> userUnBlock(int blockerId, int blockedMemberId);
  Future<List<BlockedUser>?> getBlockedUserList();
}