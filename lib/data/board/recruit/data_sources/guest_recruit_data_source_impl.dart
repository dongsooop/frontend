import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/recruit/data_sources/guest_recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

class GuestRecruitDataSourceImpl implements GuestRecruitDataSource {
  final Dio _plainDio;

  GuestRecruitDataSourceImpl(this._plainDio);

  @override
  Future<List<RecruitListModel>> fetchGuestList({
    required RecruitType type,
    required int page,
  }) async {
    final url = '${type.recruitEndpoint}';

    final response = await _plainDio.get(
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
  Future<RecruitDetailModel> fetchGuestDetail({
    required int id,
    required RecruitType type,
  }) async {
    final url = '${type.recruitEndpoint}/$id';
    final response = await _plainDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>)
        throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
      return RecruitDetailModel.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }
}
