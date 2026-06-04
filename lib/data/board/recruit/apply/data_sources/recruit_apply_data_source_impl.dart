import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_detail_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_list_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_apply_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_apply_text_filter_model.dart';
import 'package:dongsoop/data/board/recruit/config/recruit_type_config.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecruitApplyDataSourceImpl implements RecruitApplyDataSource {
  final Dio _authDio;

  RecruitApplyDataSourceImpl(this._authDio);

  @override
  Future<void> filterApply({
    required RecruitApplyTextFilterEntity entity,
  }) async {
    final model = RecruitApplyTextFilterModel.fromEntity(entity);
    final url = dotenv.get("RECRUIT_APPLY_FILTER_ENDPOINT");

    try {
      final response = await _authDio.post(url, data: model.toJson());

      if (response.statusCode == HttpStatusCode.ok.code) {
        return;
      }

      throw Exception('Unexpected status: ${response.statusCode}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status == HttpStatusCode.badRequest.code &&
          data is Map<String, dynamic>) {
        throw ProfanityDetectedException(data);
      }
      rethrow;
    }
  }

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

    try {
      final response = await _authDio.get(url);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        if (data is! List) throw FormatException('응답 데이터 형식이 List가 아닙니다.');
        return data.map((e) => RecruitApplicantListModel.fromJson(e)).toList();
      }
      throw Exception('status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundBoardException();
      }
      rethrow;
    }
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

  @override
  Future<RecruitApplicantDetailModel> recruitApplicantDetailStatus({
    required RecruitType type,
    required int boardId,
  }) async {
    final baseUrl = RecruitTypeConfig.getApplyEndpoint(type);
    final url = '$baseUrl/self/$boardId';

    try {
      final response = await _authDio.get(url);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
        }
        return RecruitApplicantDetailModel.fromJson(data);
      }
      throw Exception('status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundBoardException();
      }
      rethrow;
    }
  }

  @override
  Future<void> recruitDecision({
    required RecruitType type,
    required int boardId,
    required int applierId,
    required String status,
  }) async {
    final baseUrl = RecruitTypeConfig.getApplyEndpoint(type);
    final url = '$baseUrl/$boardId';

    final response = await _authDio.patch(
      url,
      data: {
        'status': status,
        'applierId': applierId,
      },
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
