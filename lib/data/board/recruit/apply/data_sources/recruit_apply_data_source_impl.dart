import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_apply_model.dart';
import 'package:dongsoop/data/board/recruit/config/recruit_type_config.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitApplyDataSourceImpl implements RecruitApplyDataSource {
  final Dio _authDio;
  RecruitApplyDataSourceImpl(this._authDio);

  @override
  Future<void> submitRecruitApply({
    required RecruitType type,
    required RecruitApplyEntity entity,
  }) async {
    final model = RecruitApplyModel.fromEntity(entity);
    final url = RecruitTypeConfig.getApplyEndpoint(type);
    final response = await _authDio.post(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.created.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
