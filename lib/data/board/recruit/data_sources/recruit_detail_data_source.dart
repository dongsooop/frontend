import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailDataSource {
  final Dio _authDio;
  RecruitDetailDataSource(this._authDio);

  Future<RecruitDetailModel> fetchDetailList({
    required int id,
    required RecruitType type,
  }) async {
    final url = '${type.detailEndpoint}/$id';

    try {
      final response = await _authDio.get(url);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        if (data is! Map<String, dynamic>) {
          logger.e('[RecruitDetail] 응답 형식 오류: ${data.runtimeType}');
          throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
        }
        logger.i('[RecruitDetail] 응답 성공');
        return RecruitDetailModel.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      logger.e('[RecruitDetail] DioException 발생',
          error: e.message, stackTrace: e.stackTrace);
      rethrow;
    } catch (e, st) {
      logger.e('[RecruitDetail] 알 수 없는 예외 발생',
          error: e.toString(), stackTrace: st);
      rethrow;
    }
  }
}
