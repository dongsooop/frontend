import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_detail_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_list_model.dart';
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

  @override
  Future<List<RecruitApplicantListModel>> recruitApplicantList({
    required RecruitType type,
    required int boardId,
  }) async {
    final baseUrl = RecruitTypeConfig.getApplyEndpoint(type);
    final url = '$baseUrl/$boardId';

    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      return data.map((e) => RecruitApplicantListModel.fromJson(e)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<RecruitApplicantDetailModel> recruitApplicantDetail({
    required RecruitType type,
    required int boardId,
    required int memberId,
  }) async {
    final baseUrl = RecruitTypeConfig.getApplyEndpoint(type);
    final url = '$baseUrl/$boardId/applier/$memberId';
    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>)
        throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
      return RecruitApplicantDetailModel.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }
}
