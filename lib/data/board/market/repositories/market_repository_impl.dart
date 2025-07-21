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

class MarketRepositoryImpl implements MarketRepository {
  final MarketDataSource _dataSource;

  MarketRepositoryImpl(this._dataSource);

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
  }) async {
    return _handle(() async {
      await _dataSource.requestMarketAI(entity: entity);
    }, MarketWriteException());
  }

  @override
  Future<void> submitMarket({
    required MarketWriteEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitMarket(entity: entity);
    }, MarketWriteException());
  }

  @override
  Future<void> updateMarket({
    required int marketId,
    required MarketWriteEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.updateMarket(marketId: marketId, entity: entity);
    }, MarketUpdateException());
  }

  @override
  Future<void> deleteMarket({
    required int marketId,
  }) async {
    return _handle(() async {
      await _dataSource.deleteMarket(marketId: marketId);
    }, MarketDeleteException());
  }

  @override
  Future<void> completeMarket({
    required int marketId,
  }) async {
    return _handle(() async {
      await _dataSource.completeMarket(marketId: marketId);
    }, MarketCloseException());
  }

  @override
  Future<void> contactMarket({
    required int marketId,
  }) async {
    return _handle(() async {
      await _dataSource.contactMarket(marketId: marketId);
    }, MarketContactException());
  }

  Future<T> _handle<T>(
    Future<T> Function() action,
    Exception defaultException,
  ) async {
    try {
      return await action();
    } on ProfanityDetectedException {
      rethrow;
    } on MarketAlreadyContactException {
      rethrow;
    } catch (e) {
      throw defaultException;
    }
  }
}
