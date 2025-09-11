import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/config/recruit_type_config.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_text_filter_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecruitDataSourceImpl implements RecruitDataSource {
  final Dio _authDio;
  final Dio _aiDio;

  RecruitDataSourceImpl(this._authDio, this._aiDio);

  @override
  Future<List<RecruitListModel>> fetchList({
    required RecruitType type,
    required int page,
    required String? departmentType,
  }) async {
    final baseUrl = RecruitTypeConfig.getRecruitEndpoint(type);
    final url = '$baseUrl/department/$departmentType';

    final response = await _authDio.get(
      url,
      queryParameters: {
        'page': page,
        'size': 10,
        'sort': ['id,desc', 'endAt,asc', 'startAt,asc', 'createdAt,asc'],
      },
    );

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      return data.map((e) => RecruitListModel.fromJson(e)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<RecruitDetailModel> fetchDetail({
    required int id,
    required RecruitType type,
  }) async {
    final baseUrl = RecruitTypeConfig.getRecruitEndpoint(type);
    final url = '$baseUrl/$id';

    try {
      final response = await _authDio.get(url);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        if (data is! Map<String, dynamic>) {
          throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
        }
        return RecruitDetailModel.fromJson(data);
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
  Future<void> filterPost({
    required RecruitTextFilterEntity entity,
  }) async {
    final model = RecruitTextFilterModel.fromEntity(entity);
    final url = dotenv.get("RECRUIT_WRITE_FILTER_ENDPOINT");

    try {
      final response = await _aiDio.post(url, data: model.toJson());

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
  Future<void> submitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    final model = RecruitWriteModel.fromEntity(entity);
    final url = RecruitTypeConfig.getRecruitEndpoint(type);
    final response = await _authDio.post(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.created.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deletePost({
    required int id,
    required RecruitType type,
  }) async {
    final baseUrl = RecruitTypeConfig.getRecruitEndpoint(type);
    final url = '$baseUrl/$id';
    final response = await _authDio.delete(url);

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
