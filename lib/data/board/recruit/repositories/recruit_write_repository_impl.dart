import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/model/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_write_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitWriteRepositoryImpl implements RecruitWriteRepository {
  final Dio dio;

  RecruitWriteRepositoryImpl(this.dio);

  @override
  Future<void> fetchRecruitWrite({
    required RecruitType type,
    required String accessToken,
    required RecruitWriteEntity entity,
  }) async {
    final endpoint = type.writeEndpoint;
    final model = RecruitWriteModel.fromEntity(entity);

    try {
      print('[WRITE_REQUEST] POST $endpoint');
      print('[REQUEST_BODY] ${model.toJson()}');
      await dio.post(
        endpoint,
        data: model.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('[WRITE_SUCCESS] ${type.name} 작성 성공');
    } on DioException catch (e) {
      print('[WRITE_FAIL] DioException: ${e.message}');
      throw Exception('${type.name} 작성 실패: ${e.message}');
    } catch (e) {
      print('[WRITE_FAIL] Unknown Error: $e');
      throw Exception('예상치 못한 오류 발생: $e');
    }
  }
}
