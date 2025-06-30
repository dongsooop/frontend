import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/market/data_sources/market_data_source.dart';
import 'package:dongsoop/data/board/market/models/market_detail_model.dart';
import 'package:dongsoop/data/board/market/models/market_list_model.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GuestMarketDataSourceImpl implements MarketDataSource {
  final Dio _plainDio;

  GuestMarketDataSourceImpl(this._plainDio);

  @override
  Future<List<MarketListModel>> fetchMarketList({
    required MarketType type,
    required int page,
  }) async {
    final baseUrl = dotenv.get("MARKET_ENDPOINT");
    final url = '$baseUrl/type/${type.name}';

    final response = await _plainDio.get(
      url,
      queryParameters: {
        'page': page,
        'size': 10,
        'sort': ['id,desc', 'createdAt,asc'],
      },
    );

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      return data.map((e) => MarketListModel.fromJson(e)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<MarketDetailModel> fetchMarketDetail({
    required int id,
  }) async {
    final baseUrl = dotenv.get("MARKET_ENDPOINT");
    final url = '$baseUrl/$id';
    final response = await _plainDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
      }
      return MarketDetailModel.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }

  // 이중 막음
  @override
  Future<void> requestMarketAI({
    required entity,
  }) {
    throw LoginRequiredException();
  }

  @override
  Future<void> submitMarket({required entity}) {
    throw LoginRequiredException();
  }

  @override
  Future<void> updateMarket({
    required int marketId,
    required entity,
  }) {
    throw LoginRequiredException();
  }

  @override
  Future<void> deleteMarket({
    required int marketId,
  }) {
    throw LoginRequiredException();
  }

  @override
  Future<void> completeMarket({
    required int marketId,
  }) {
    throw LoginRequiredException();
  }
}
