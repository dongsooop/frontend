import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitWriteDataSource {
  final Dio _authDio;

  RecruitWriteDataSource(this._authDio);

  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    final endpoint = type.writeEndpoint;
    final model = RecruitWriteModel.fromEntity(entity);
    final jsonBody = model.toJson();

    try {
      logger.i('[RecruitWrite] Payload: $jsonBody');

      final response = await _authDio.post(endpoint, data: jsonBody);

      if (response.statusCode == HttpStatusCode.ok.code) {
        logger.i('[RecruitWrite] 모집글 작성 성공');
        return;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      logger.e('[RecruitWrite] DioException 발생',
          error: {
            'statusCode': status,
            'message': e.message,
            'responseBody': e.response?.data,
          },
          stackTrace: e.stackTrace);
      rethrow;
    } catch (e, st) {
      logger.e('[RecruitWrite] 알 수 없는 예외 발생', error: e, stackTrace: st);
      rethrow;
    }
  }
}
