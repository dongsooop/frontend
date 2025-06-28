import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketUpdateUseCase {
  final MarketRepository _repo;

  MarketUpdateUseCase(this._repo);

  Future<void> execute({
    required int marketId,
    required MarketWriteEntity entity,
  }) async {
    return _repo.updateMarket(
      marketId: marketId,
      entity: entity,
    );
  }
}
