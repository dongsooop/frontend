import 'package:dio/dio.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailDataSource {
  final Dio dio;

  RecruitDetailDataSource(this.dio);

  Future<RecruitDetailModel> getRecruitDetailApi(
      RecruitDetailParams params) async {
    final baseEndpoint = params.type.detailEndpoint;
    final url = '${baseEndpoint}/${params.id}';

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${params.accessToken}',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    return RecruitDetailModel.fromJson(data);
  }
}
