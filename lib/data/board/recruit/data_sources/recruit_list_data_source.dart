import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitListDataSource {
  final Dio dio;

  RecruitListDataSource(this.dio);

  Future<List<RecruitListModel>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String accessToken,
    required String departmentType,
  }) async {
    final baseEndpoint = type.listEndpoint;
    final url = '$baseEndpoint$departmentType';

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
        .map((item) => RecruitListModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
