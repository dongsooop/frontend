import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/model/detail/recruit_detail_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/detail/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/detail/recruit_detail_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailRepositoryImpl implements RecruitDetailRepository {
  final Dio dio;

  RecruitDetailRepositoryImpl(this.dio);

  @override
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
    required String accessToken,
  }) async {
    final baseEndpoint = type.detailEndpoint;
    final url = '$baseEndpoint/$id';

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final data = response.data as Map<String, dynamic>;
      final model = RecruitDetailModel.fromJson(data);
      return model.toEntity();
    } on DioException catch (e) {
      throw Exception('${type.name} 상세 불러오기 실패: ${e.message}');
    } catch (e) {
      throw Exception('예상치 못한 오류 발생: $e');
    }
  }
}
