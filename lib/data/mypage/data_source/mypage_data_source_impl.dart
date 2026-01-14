import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/http_status_code.dart';

class MypageDataSourceImpl implements MypageDataSource {
  final Dio _authDio;

  MypageDataSourceImpl(
    this._authDio,
  );

  @override
  Future<List<MypageMarket>?> getMarketPosts({int page = 0, int size = 10,}) async {
    final market = dotenv.get('MYPAGE_MARKET_ENDPOINT');
    final query = 'page=$page&size=$size&sort=createdAt,asc';
    final endpoint = '$market?$query';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<MypageMarket> posts = data.map((e) => MypageMarket.fromJson(e as Map<String, dynamic>)).toList();
        return posts;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,}) async {
    final market = isApply ? dotenv.get('MYPAGE_APPLY_RECRUIT_ENDPOINT') : dotenv.get('MYPAGE_OPEND_RECRUIT_ENDPOINT');
    final query = 'page=$page&size=$size';
    final endpoint = '$market?$query';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<MypageRecruit> posts = data.map((e) => MypageRecruit.fromJson(e)).toList();
        return posts;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BlockedUser>?> getBlockedUserList() async {
    final endpoint = dotenv.get('BLOCK_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<BlockedUser> list = data.map((e) => BlockedUser.fromJson(e as Map<String, dynamic>)).toList();
        return list;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> userUnBlock(int blockerId, int blockedMemberId) async {
    final endpoint = dotenv.get('BLOCK_ENDPOINT');
    final requestBody = {"blockerId": blockerId, "blockedMemberId": blockedMemberId};

    try {
      await _authDio.delete(endpoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> blindDateOpen(BlindDateOpenRequest request) async {
    final endpoint = dotenv.get('BLIND_DATE_OPEN_ENDPOINT');

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SocialState>> getSocialStateList() async {
    final endpoint = dotenv.get('SOCIAL_STATE_ENDPOINT');

    try {
      final dummy = <Map<String, dynamic>>[
        // {"providerType": "APPLE", "createdAt": "2026-01-01 10:00:00"},
        // {"providerType": "GOOGLE", "createdAt": "2026-01-01 10:00:00"},
      ];

      return dummy.map((e) =>
          SocialState.fromJson(e)).toList();
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<SocialState> list = data.map((e) =>
            SocialState.fromJson(e as Map<String, dynamic>)).toList();
        return list;
      }
      throw OAuthException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken) async {
    final endpoint = dotenv.get('SOCIAL_LINK_ENDPOINT');
    final url = endpoint + '/${platform.name}';
    final requestBody = {
      "token": socialToken,
    };

    try {
      final response = await _authDio.post(url, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final createdAt = response.data['createdAt'];
        print('${platform.label} 계정 연동 성공 - $createdAt');
        return createdAt;
      }
      throw OAuthException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> unlinkSocialAccount(LoginPlatform platform, String socialToken) async {
    final endpoint = dotenv.get('SOCIAL_LOGIN_ENDPOINT');
    final url = endpoint + '/${platform.name}';
    // 카카오는 토큰 X
    final requestBody = {
      "token": platform.name == 'kakao' ? null : socialToken,
    };

    try {
      final response = await _authDio.delete(url, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        print('${platform.label} 계정 해제 성공');
        return true;
      }
      throw OAuthException();
    }  on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.unauthorized.code) {
        throw SocialUnlinkUserException();
      }
      throw OAuthException();
    } catch (e) {
      rethrow;
    }
  }
}