import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/mypage/model/blind_date_open_request.dart';
import 'package:dongsoop/domain/mypage/model/blocked_user.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
import 'package:dongsoop/domain/mypage/model/social_state.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:flutter/foundation.dart';

class MypageDataSourceImpl implements MypageDataSource {
  final Dio _authDio;

  MypageDataSourceImpl(
    this._authDio,
  );

  @override
  Future<List<MypageMarket>?> getMarketPosts({int page = 0, int size = 10,}) async {
    final market = '/mypage/opened-marketplace';
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
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<List<MypageRecruit>?> getRecruitPosts(bool isApply, {int page = 0, int size = 10,}) async {
    final market = isApply ? '/mypage/apply-recruitments' : '/mypage/opened-recruitments';
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
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<List<BlockedUser>?> getBlockedUserList() async {
    final endpoint = '/member-block';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<BlockedUser> list = data.map((e) => BlockedUser.fromJson(e as Map<String, dynamic>)).toList();
        return list;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<void> userUnBlock(int blockerId, int blockedMemberId) async {
    final endpoint = '/member-block';
    final requestBody = {"blockerId": blockerId, "blockedMemberId": blockedMemberId};

    try {
      await _authDio.delete(endpoint, data: requestBody);
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<bool> blindDateOpen(BlindDateOpenRequest request) async {
    final endpoint = '/blinddate';

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        print('blindDateOpen: ${e}');
        throw BlindDateOpenConflictException();
      }
      rethrow;
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<void> resetBlindDateParticipants() async {
    const endpoint = '/participants';
    _logBlindDateReset('REQUEST method=DELETE endpoint=$endpoint');

    try {
      final response = await _authDio.delete(endpoint);
      final statusCode = response.statusCode;
      _logBlindDateReset(
        'RESPONSE status=$statusCode body=${response.data ?? '-'}',
      );
      if (statusCode != null && statusCode >= 200 && statusCode < 300) {
        _logBlindDateReset('SUCCESS');
        return;
      }
      throw Exception('Unexpected status code: $statusCode');
    } catch (e) {
      if (e is DioException) {
        _logBlindDateReset(
          'ERROR type=${e.type.name} '
          'status=${e.response?.statusCode ?? '-'} '
          'message=${e.message ?? '-'} '
          'body=${e.response?.data ?? '-'}',
        );
      } else {
        _logBlindDateReset('ERROR type=${e.runtimeType} message=$e');
      }
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<List<SocialState>> getSocialStateList() async {
    final endpoint = '/oauth2/state';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;
        final List<SocialState> list = data.map((e) =>
            SocialState.fromJson(e as Map<String, dynamic>)).toList();
        return list;
      }
      throw OAuthException();
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<DateTime> linkSocialAccount(LoginPlatform platform, String socialToken) async {
    final endpoint = '/oauth2/link';
    final url = endpoint + '/${platform.name}';
    final requestBody = {
      "providerToken": socialToken,
    };

    try {
      final response = await _authDio.post(url, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final createdAt = DateTime.parse(response.data);
        return createdAt;
      }
      throw OAuthException();
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  @override
  Future<bool> unlinkSocialAccount(LoginPlatform platform, String socialToken) async {
    final endpoint = '/oauth2';
    final url = endpoint + '/${platform.name}';
    // 카카오는 토큰 X
    final requestBody = {
      "token": platform.name == 'kakao' ? 'mobile' : socialToken,
    };

    try {
      final response = await _authDio.delete(url, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw OAuthException();
    }  on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.unauthorized.code) {
        throw SocialUnlinkUserException();
      }
      throw OAuthException();
    } catch (e) {
      if (e is DioException && e.error is SessionExpiredException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  void _logBlindDateReset(String message) {
    if (kDebugMode) {
      debugPrint('[BlindDate Admin] RESET $message');
    }
  }
}
