import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_write_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

class RecruitDataSourceImpl implements RecruitDataSource {
  final Dio _authDio;

  RecruitDataSourceImpl(this._authDio);

  @override
  Future<List<RecruitListModel>> fetchList({
    required RecruitType type,
    required int page,
    required String? departmentType,
  }) async {
    final url = '${type.listEndpoint}$departmentType';

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
    final url = '${type.detailEndpoint}/$id';
    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>)
        throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
      return RecruitDetailModel.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> submitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    final model = RecruitWriteModel.fromEntity(entity);
    final response =
        await _authDio.post(type.writeEndpoint, data: model.toJson());

    if (response.statusCode != HttpStatusCode.created.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
