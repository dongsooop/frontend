import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';

abstract class MypageDataSource {
  Future<void> userUnBlock(int blockerId, int blockedMemberId);
  Future<List<BlockedUser>?> getBlockedUserList();
  Future<bool> blindDateOpen(BlindDateOpenRequest request);
  Future<void> resetBlindDateParticipants();
  Future<List<SocialState>> getSocialStateList();
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken);
  Future<bool> unlinkSocialAccount(LoginPlatform platform, String socialToken);
}
