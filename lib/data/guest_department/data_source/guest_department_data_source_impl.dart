import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/guest_department/data_source/guest_department_data_source.dart';
import 'package:dongsoop/data/guest_department/model/guest_department_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GuestDepartmentDataSourceImpl implements GuestDepartmentDataSource {
  final Dio _plainDio;

  GuestDepartmentDataSourceImpl(this._plainDio);

  @override
  Future<GuestDepartmentModel> fetchDepartments({
    required String deviceToken,
  }) async {
    final url = dotenv.get('GUEST_DEPARTMENT_FIND');

    final response = await _plainDio.get(
      url,
      options: Options(headers: {'X-Device-Token': deviceToken}),
    );

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception(
        'GuestDepartment FIND failed. status: ${response.statusCode}',
      );
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception(
        'GuestDepartment FIND invalid response type: ${data.runtimeType}',
      );
    }

    return GuestDepartmentModel.fromJson(data);
  }

  @override
  Future<void> updateDepartments({
    required String deviceToken,
    required GuestDepartmentModel body,
  }) async {
    final url = dotenv.get('GUEST_DEPARTMENT_UPDATE');

    final response = await _plainDio.put(
      url,
      data: body.toJson(),
      options: Options(headers: {'X-Device-Token': deviceToken}),
    );

    if (response.statusCode != HttpStatusCode.ok.code &&
        response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception(
        'GuestDepartment UPDATE failed. status: ${response.statusCode}',
      );
    }
  }
}
