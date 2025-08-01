import 'package:dio/dio.dart';
import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/mypage/model/mypage_market.dart';
import 'package:dongsoop/domain/mypage/model/mypage_recruit.dart';
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
}