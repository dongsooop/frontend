import 'package:dongsoop/data/board/market/models/market_detail_model.dart';
import 'package:dongsoop/data/board/market/models/market_list_model.dart';
import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';

abstract class MarketDataSource {
  Future<List<MarketListModel>> fetchMarketList({
    required MarketType type,
    required int page,
  });

  Future<MarketDetailModel> fetchMarketDetail({
    required MarketType type,
    required int id,
  });

  Future<void> submitMarket({
    required MarketWriteEntity entity,
  });

  Future<void> requestMarketAI({
    required MarketAIFilterEntity entity,
  });

  Future<void> updateMarket({
    required int marketId,
    required MarketWriteEntity entity,
  });

  Future<void> deleteMarket({
    required int marketId,
  });
}
