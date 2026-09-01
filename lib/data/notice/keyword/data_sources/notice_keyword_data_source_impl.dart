import 'package:dio/dio.dart';
import 'package:dongsoop/domain/device_token/use_case/get_fcm_token_use_case.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';

/// 키워드는 회원이 아니라 기기에 붙는다.
///
/// 그래서 인증 대신 기기 헤더로 대상을 정하는 `/v2/notice/keywords` 를 쓴다.
/// 비회원도 자기 기기의 키워드를 설정할 수 있고, 로그아웃해도 설정이 남는다.
/// 헤더 규칙은 `SubscribeDepartmentDataSourceImpl` 과 같다.
class NoticeKeywordDataSourceImpl implements NoticeKeywordDataSource {
  final Dio _plainDio;
  final GetFcmTokenUseCase _getFcmTokenUseCase;

  NoticeKeywordDataSourceImpl(this._plainDio, this._getFcmTokenUseCase);

  /// 구버전 경로(`NOTICE_KEYWORD_ENDPOINT`)에서 v2 경로를 만든다.
  /// 새 환경변수를 두면 배포마다 .env 를 함께 갱신해야 해서 기존 값에서 파생시킨다.
  String get _endpoint {
    final base = dotenv.get('NOTICE_KEYWORD_ENDPOINT');
    return base.startsWith('/') ? '/v2$base' : '/v2/$base';
  }

  /// 기기 토큰이 없으면 대상 기기를 특정할 수 없다.
  Future<Options> _deviceOptions() async {
    final deviceToken = await _getFcmTokenUseCase.execute();

    if (deviceToken == null || deviceToken.isEmpty) {
      throw Exception('device token is not ready');
    }

    return Options(headers: {'X-Device-Token': deviceToken});
  }

  @override
  Future<List<NoticeKeywordEntity>> getKeywords() async {
    try {
      final response = await _plainDio.get(
        _endpoint,
        options: await _deviceOptions(),
      );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final list = response.data as List;
        return list.map((json) => NoticeKeywordEntity.fromJson(json)).toList();
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NoticeKeywordEntity> addKeyword({
    required String keyword,
    required NoticeKeywordType type,
  }) async {
    final requestBody = {
      'keyword': keyword,
      'type': type.name.toUpperCase(),
    };

    try {
      final response = await _plainDio.post(
        _endpoint,
        data: requestBody,
        options: await _deviceOptions(),
      );

      if (response.statusCode == HttpStatusCode.created.code) {
        return NoticeKeywordEntity.fromJson(response.data);
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteKeyword(int keywordId) async {
    final endpoint = _endpoint + '/$keywordId';

    try {
      final response = await _plainDio.delete(
        endpoint,
        options: await _deviceOptions(),
      );

      if (response.statusCode != HttpStatusCode.noContent.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
