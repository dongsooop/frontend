import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitListDataSource {
  final Dio _plainDio;
  RecruitListDataSource(this._plainDio);

  Future<List<RecruitListModel>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  }) async {
    try {
      final baseEndpoint = type.listEndpoint;
      final url = '$baseEndpoint$departmentType';

      final response = await _plainDio.get(
        url,
        queryParameters: {
          'page': page,
          'size': 10,
          'sort': ['id,desc', 'createdAt,asc'],
        },
      );

      final data = response.data;

      if (data is List) {
        return data
            .map((item) =>
                RecruitListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Invalid response format: expected a List');
      }
    } on DioException catch (e) {
      throw Exception('[DioError] ${e.response?.statusCode} - ${e.message}');
    } catch (e) {
      throw Exception('Unknown error while fetching recruit list: $e');
    }
  }
}
