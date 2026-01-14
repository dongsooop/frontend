import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';

abstract class MypageDataSource {
  Future<List<MypageMarket>?> getMarketPosts({int page = 0, int size = 10,});
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,});
  Future<void> userUnBlock(int blockerId, int blockedMemberId);
  Future<List<BlockedUser>?> getBlockedUserList();
  Future<bool> blindDateOpen(BlindDateOpenRequest request);
  Future<List<SocialState>> getSocialStateList();
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken);
  Future<bool> unlinkSocialAccount(LoginPlatform platform, String socialToken);
}