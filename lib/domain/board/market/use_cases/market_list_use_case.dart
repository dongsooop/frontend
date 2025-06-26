import 'package:dongsoop/domain/board/market/entities/market_list_entity.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketListUseCase {
  final MarketRepository repository;

  MarketListUseCase(this.repository);

  Future<List<MarketListEntity>> execute({
    required MarketType type,
    required int page,
  }) async {
    return repository.fetchMarketList(
      type: type,
      page: page,
    );
  }
}
