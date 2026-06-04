import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/data_sources/notice_data_source.dart';
import 'package:dongsoop/data/notice/model/notice_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticeDataSourceImpl implements NoticeDataSource {
  final Dio _plainDio;
  final Dio _authDio;

  NoticeDataSourceImpl(this._plainDio, this._authDio);

  @override
  Future<List<NoticeModel>> fetchSchoolNotices({required int page}) async {
    final endpoint = dotenv.get('SCHOOL_NOTICE_ENDPOINT');
    return _fetchNoticesFromUrl(
      dio: _plainDio,
      url: endpoint,
      page: page,
    );
  }

  @override
  Future<List<NoticeModel>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
  }) async {
    final prefix = dotenv.get('DEPARTMENT_NOTICE_ENDPOINT');
    final url = '$prefix$departmentType';
    return _fetchNoticesFromUrl(
      dio: _authDio,
      url: url,
      page: page,
    );
  }

  Future<List<NoticeModel>> _fetchNoticesFromUrl({
    required Dio dio,
    required String url,
    required int page,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'page': page,
          'size': 10,
          'sort': 'id,desc',
        },
      );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        if (data is! Map || data['content'] is! List) {
          throw FormatException('잘못된 응답 형식입니다: $data');
        }

        final list = data['content'] as List;
        return list.map((json) => NoticeModel.fromJson(json)).toList();
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}