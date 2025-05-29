import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/model/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_list_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitListRepositoryImpl implements RecruitListRepository {
  final Dio dio;

  RecruitListRepositoryImpl(this.dio);

  @override
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String accessToken,
    required String departmentType,
  }) async {
    final baseEndpoint = type.listEndpoint;
    final url = '$baseEndpoint$departmentType';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'page': page,
          'size': 10,
          'sort': ['id,desc', 'createdAt,asc'],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final data = response.data as List<dynamic>;

      return data
          .map((item) => RecruitListModel.fromJson(item as Map<String, dynamic>)
              .toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('${type.name} 리스트 불러오기 실패: ${e.message}');
    } catch (e) {
      throw Exception('예상치 못한 오류 발생: $e');
    }
  }
}
