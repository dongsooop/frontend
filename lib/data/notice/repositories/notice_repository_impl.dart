import 'package:dio/dio.dart';
import 'package:dongsoop/data/notice/models/notice_model.dart';
import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/repositories/notice_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticeRepositoryImpl implements NoticeRepository {
  final Dio dio;
  NoticeRepositoryImpl(this.dio);

  @override
  Future<List<NoticeEntity>> fetchSchoolNotices({required int page}) async {
    final baseUrl = dotenv.get('BASE_URL');
    final endpoint = dotenv.get('SCHOOL_NOTICE_ENDPOINT');
    final url = '$baseUrl$endpoint';
    return _fetchNoticesFromUrl(url, page, isDepartment: false);
  }

  @override
  Future<List<NoticeEntity>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
  }) async {
    final baseUrl = dotenv.get('BASE_URL');
    final prefix = dotenv.get('DEPARTMENT_NOTICE_ENDPOINT');
    final url = '$baseUrl$prefix$departmentType';
    return _fetchNoticesFromUrl(url, page, isDepartment: true);
  }

  Future<List<NoticeEntity>> _fetchNoticesFromUrl(String url, int page,
      {required bool isDepartment}) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: {'page': page, 'size': 10},
      );

      final data = response.data;
      if (data is Map && data['content'] is List) {
        final list = data['content'] as List;
        return list
            .map((json) =>
                NoticeModel.fromJson(json).toEntity(isDepartment: isDepartment))
            .toList();
      } else {
        throw FormatException('Unexpected response format: $data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
