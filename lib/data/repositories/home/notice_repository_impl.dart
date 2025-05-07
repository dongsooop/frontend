import 'package:dio/dio.dart';
import 'package:dongsoop/data/models/home/notice_model.dart';
import 'package:dongsoop/domain/entites/home/notice_entity.dart';
import 'package:dongsoop/domain/repositories/home/notice_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 공지사항 데이터를 백엔드 API에서 가져오는 Repository 구현체
/// Dio를 사용하여 HTTP 요청을 보내고, 응답 데이터를 NoticeEntity로 변환하여 반환함
class NoticeRepositoryImpl implements NoticeRepository {
  final Dio dio;

  /// Dio 인스턴스를 주입받는 생성자
  NoticeRepositoryImpl(this.dio);

  /// 공지사항 목록을 비동기로 가져오는 함수
  @override
  Future<List<NoticeEntity>> fetchNotices({required int page}) async {
    // .env 파일에서 API 기본 URL과 엔드포인트 로딩
    final baseUrl = dotenv.get('BASE_URL');
    final endpoint = dotenv.get('NOTICE_ENDPOINT');
    final fullUrl = '$baseUrl$endpoint';

    try {
      // Dio를 사용해 GET 요청 전송 (헤더 제거됨)
      final response = await dio.get(
        fullUrl,
        queryParameters: {
          'page': page,
          'size': 10,
          // 'sort': ['name,asc', 'date,des'],
        },
      );

      // 디버깅용 로그 출력
      print('응답 성공');
      print('응답 데이터: ${response.data}');

      final data = response.data;

      // 응답 데이터가 Map이고 'content' 키에 리스트가 포함된 경우
      if (data is Map && data['content'] is List) {
        final list = data['content'] as List;
        return list
            .map((json) => NoticeModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw FormatException('예상하지 못한 응답 형식: $data');
      }
    } on DioException catch (e) {
      print('DioException');
      print('요청 URL: ${e.requestOptions.uri}');
      print('상태 코드: ${e.response?.statusCode}');
      print('응답 데이터: ${e.response?.data}');
      // print('요청 헤더: ${e.requestOptions.headers}');
      // print('응답 헤더: ${e.response?.headers}');
      rethrow;
    } catch (e) {
      print('알 수 없는 에러: $e');
      rethrow;
    }
  }
}
