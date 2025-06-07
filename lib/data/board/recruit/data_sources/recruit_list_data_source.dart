import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/main.dart';

class RecruitListDataSource {
  final Dio _authDio;

  RecruitListDataSource(this._authDio);

  Future<List<RecruitListModel>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  }) async {
    final baseEndpoint = type.listEndpoint;
    final url = '$baseEndpoint$departmentType';

    try {
      final response = await _authDio.get(
        url,
        queryParameters: {
          'page': page,
          'size': 10,
          'sort': ['id,desc', 'endAt,asc', 'startAt,asc', 'createdAt,asc'],
        },
      );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        if (data is! List) {
          logger.e('[RecruitList] 응답 형식 오류: ${data.runtimeType}');
          throw FormatException('응답 데이터 형식이 List가 아닙니다.');
        }

        logger.i('[RecruitList] 응답 성공: 항목 수=${data.length}');
        return data
            .map((item) =>
                RecruitListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      logger.e('[RecruitList] DioException 발생',
          error: e.message, stackTrace: e.stackTrace);
      rethrow;
    } catch (e, st) {
      logger.e('[RecruitList] 알 수 없는 예외 발생',
          error: e.toString(), stackTrace: st);
      rethrow;
    }
  }
}
