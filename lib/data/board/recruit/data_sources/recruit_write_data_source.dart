import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitWriteDataSource {
  final Dio dio;

  RecruitWriteDataSource(this.dio);

  Future<void> submitRecruitPost({
    required RecruitType type,
    required String accessToken,
    required RecruitWriteEntity entity,
  }) async {
    final endpoint = type.writeEndpoint;
    final model = RecruitWriteModel.fromEntity(entity);
    final jsonBody = model.toJson();

    try {
      await dio.post(
        endpoint,
        data: jsonBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      print('[WRITE_FAIL] Unknown Error: $e');
      throw Exception('예상치 못한 오류 발생: $e');
    }
  }
}
