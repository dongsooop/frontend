import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/market/data_sources/market_data_source.dart';
import 'package:dongsoop/data/board/market/models/market_detail_model.dart';
import 'package:dongsoop/data/board/market/models/market_list_model.dart';
import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class GuestMarketRepositoryImpl implements MarketRepository {
  final MarketDataSource _dataSource;

  GuestMarketRepositoryImpl(this._dataSource);

  @override
  Future<List<MarketListEntity>> fetchMarketList({
    required MarketType type,
    required int page,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchMarketList(type: type, page: page);
      return models.map((model) => model.toEntity()).toList();
    }, MarketListException());
  }

  @override
  Future<MarketDetailEntity> fetchMarketDetail({
    required int id,
  }) async {
    return _handle(() async {
      final model = await _dataSource.fetchMarketDetail(id: id);
      return model.toEntity();
    }, MarketDetailException());
  }

  @override
  Future<void> requestMarketAI({
    required MarketAIFilterEntity entity,
  }) {
    throw LoginRequiredException();
  }

  @override
  Future<void> submitMarket({
    required MarketWriteEntity entity,
  }) {
    throw LoginRequiredException();
  }

  @override
  Future<void> updateMarket({
    required int marketId,
    required MarketWriteEntity entity,
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

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
