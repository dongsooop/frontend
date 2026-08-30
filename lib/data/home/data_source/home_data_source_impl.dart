import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/home/model/home_response.dart';
import 'home_data_source.dart';

class HomeDataSourceImpl implements HomeDataSource {
  final Dio _plainDio;

  HomeDataSourceImpl(this._plainDio);

  @override
  Future<HomeResponse> fetchGuestHome({String? fid, String? deviceToken}) async {
    final url = dotenv.get('HOME_ENDPOINT');
    final headers = <String, String>{
      if (fid != null && fid.isNotEmpty) 'X-Device-Fid': fid,
      if (deviceToken != null && deviceToken.isNotEmpty)
        'X-Device-Token': deviceToken,
    };

    final response = await _plainDio.get(
      url,
      options: headers.isEmpty ? null : Options(headers: headers),
    );
    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('응답이 Map<String, dynamic> 형식이 아닙니다.');
      }
      return HomeResponse.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }
}
