import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';

abstract class MypageRepository {
  Future<List<BlockedUser>?> getBlockedUserList();
  Future<void> unBlock(int blockerId, int blockedMemberId);
  Future<bool> blindOpen(BlindDateOpenRequest request);
  Future<void> resetBlindDateParticipants();
  Future<List<SocialState>> getSocialStateList();
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken);
  Future<bool> unlinkSocialAccount(platform, socialToken);
}
