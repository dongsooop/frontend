import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';

abstract class MypageRepository {
  Future<List<MypageMarket>?> getMargetPosts({int page = 0, int size = 10,});
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,});
  Future<List<BlockedUser>?> getBlockedUserList();
  Future<void> unBlock(int blockerId, int blockedMemberId);
}