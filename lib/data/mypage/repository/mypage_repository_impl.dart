import 'package:dongsoop/core/network/error_handler_mixin.dart';
import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';

class MypageRepositoryImpl with ErrorHandlerMixin implements MypageRepository {
  final MypageDataSource _mypageDataSource;

  MypageRepositoryImpl(
    this._mypageDataSource,
  );

  @override
  Future<List<MypageMarket>?> getMargetPosts({int page = 0, int size = 10})  async {
    try {
      final posts = await _mypageDataSource.getMarketPosts(page: page, size: size);
      if (posts == null || posts.isEmpty) return [];

      return posts;
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10})  async {
    try {
      final posts = await _mypageDataSource.getRecruitPosts(isApply, page: page, size: size);
      if (posts == null || posts.isEmpty) return [];

      return posts;
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<List<BlockedUser>?> getBlockedUserList() async {
    try {
      final list = await _mypageDataSource.getBlockedUserList();
      if (list == null || list.isEmpty) return [];

      return list;
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<void> unBlock(int blockerId, int blockedMemberId) async {
    try {
      await _mypageDataSource.userUnBlock(blockerId, blockedMemberId);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<bool> blindOpen(BlindDateOpenRequest request) async {
    try {
      return await _mypageDataSource.blindDateOpen(request);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<List<SocialState>> getSocialStateList() async {
    try {
      final list = await _mypageDataSource.getSocialStateList();
      if (list == null || list.isEmpty) return [];

      return list;
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken) async {
    try {
      return await _mypageDataSource.linkSocialAccount(platform, socialToken);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<bool> unlinkSocialAccount(platform, socialToken) async {
    try {
      return await _mypageDataSource.unlinkSocialAccount(platform, socialToken);
    } catch (e) {
      throw convertError(e);
    }
  }
}