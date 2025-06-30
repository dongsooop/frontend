import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/board/market/data_sources/market_data_source.dart';
import 'package:dongsoop/data/board/market/models/market_ai_filter_model.dart';
import 'package:dongsoop/data/board/market/models/market_detail_model.dart';
import 'package:dongsoop/data/board/market/models/market_list_model.dart';
import 'package:dongsoop/data/board/market/models/market_write_model.dart';
import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MarketDataSourceImpl implements MarketDataSource {
  final Dio _authDio;
  final Dio _aiDio;

  MarketDataSourceImpl(this._authDio, this._aiDio);

  @override
  Future<List<MarketListModel>> fetchMarketList({
    required MarketType type,
    required int page,
  }) async {
    final baseUrl = dotenv.get("MARKET_ENDPOINT");
    final url = '$baseUrl/type/${type.name}';

    final response = await _authDio.get(
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
    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>)
        throw FormatException('응답 데이터 형식이 Map<String, dynamic>이 아닙니다.');
      return MarketDetailModel.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> submitMarket({
    required MarketWriteEntity entity,
  }) async {
    final model = MarketWriteModel.fromEntity(entity);
    final url = dotenv.get("MARKET_ENDPOINT");

    // 요청 JSON 직렬화 및 로그
    final requestJson = jsonEncode(model.toJson());
    logger.i('[MARKET] 요청 JSON: $requestJson');

    final formData = FormData();

    // JSON 데이터 추가
    formData.files.add(MapEntry(
      'request',
      MultipartFile.fromString(
        requestJson,
        contentType: DioMediaType('application', 'json'),
      ),
    ));

    // 이미지들 추가: 키 이름은 모두 'image'
    if (entity.images != null && entity.images!.isNotEmpty) {
      for (final image in entity.images!) {
        final fileSizeMB = (await File(image.path).length()) / (1024 * 1024);
        logger.i(
            '[MARKET] 이미지 업로드 준비: ${image.name}, ${fileSizeMB.toStringAsFixed(2)}MB');

        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: image.name,
          ),
        ));
      }
    }

    try {
      final response = await _authDio.post(
        url,
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      logger.i('[MARKET] 서버 응답 status: ${response.statusCode}');
      logger.i('[MARKET] 서버 응답 body: ${response.data}');

      if (response.statusCode != HttpStatusCode.created.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } catch (e, st) {
      logger.e('게시글 등록 실패', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> requestMarketAI({
    required MarketAIFilterEntity entity,
  }) async {
    final model = MarketAIFilterModel.fromEntity(entity);
    final url = dotenv.get("MARKET_FILTER_ENDPOINT");

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
  Future<void> updateMarket({
    required int marketId,
    required MarketWriteEntity entity,
  }) async {
    final model = MarketWriteModel.fromEntity(entity);
    final url = '${dotenv.get('MARKET_ENDPOINT')}/$marketId';

    final requestJson = jsonEncode(model.toJson());
    final formData = FormData();

    formData.files.add(MapEntry(
      'request',
      MultipartFile.fromString(
        requestJson,
        contentType: DioMediaType('application', 'json'),
      ),
    ));

    if (entity.images != null && entity.images!.isNotEmpty) {
      for (final image in entity.images!) {
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            image.path,
            filename: image.name,
          ),
        ));
      }
    }

    final response = await _authDio.patch(
      url,
      data: formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteMarket({
    required int marketId,
  }) async {
    final url = '${dotenv.get('MARKET_ENDPOINT')}/$marketId';
    final response = await _authDio.delete(url);

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
