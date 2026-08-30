import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/subscribe_department/data_source/subscribe_department_data_source.dart';
import 'package:dongsoop/data/subscribe_department/model/subscribe_department_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscribeDepartmentDataSourceImpl implements SubscribeDepartmentDataSource {
  final Dio _plainDio;

  SubscribeDepartmentDataSourceImpl(this._plainDio);

  @override
  Future<SubscribeDepartmentModel> fetchDepartments({
    String? fid,
    required String deviceToken,
  }) async {
    final url = dotenv.get('SUBSCRIBE_DEPARTMENT_FIND');

    final response = await _plainDio.get(
      url,
      options: Options(headers: {
        if (fid != null && fid.isNotEmpty) 'X-Device-Fid': fid,
        'X-Device-Token': deviceToken,
      }),
    );

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception(
        'SubscribeDepartment FIND failed. status: ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception(
        'SubscribeDepartment FIND invalid response type: ${data.runtimeType}',
      );
    }

    return SubscribeDepartmentModel.fromJson(data);
  }

  @override
  Future<void> updateDepartments({
    required String deviceToken,
    required SubscribeDepartmentModel body,
  }) async {
    final url = dotenv.get('SUBSCRIBE_DEPARTMENT_UPDATE');

    final response = await _plainDio.put(
      url,
      data: body.toJson(),
      options: Options(headers: {'X-Device-Token': deviceToken}),
    );

    if (response.statusCode != HttpStatusCode.ok.code &&
        response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'SubscribeDepartment UPDATE failed. status: ${response.statusCode}',
      );
    }
  }
}
