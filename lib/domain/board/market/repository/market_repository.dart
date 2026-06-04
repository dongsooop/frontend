import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';

abstract class MarketRepository {
  Future<List<MarketListEntity>> fetchMarketList({
    required MarketType type,
    required int page,
  });

  Future<MarketDetailEntity> fetchMarketDetail({
    required int id,
  });

  Future<void> requestMarketAI({
    required MarketAIFilterEntity entity,
  });

  Future<void> submitMarket({
    required MarketWriteEntity entity,
  });

  Future<void> updateMarket({
    required int marketId,
    required MarketWriteEntity entity,
  });

  Future<void> deleteMarket({
    required int marketId,
  });

  Future<void> completeMarket({
    required int marketId,
  });

  Future<String> contactMarket({
    required int marketId,
  });
}
