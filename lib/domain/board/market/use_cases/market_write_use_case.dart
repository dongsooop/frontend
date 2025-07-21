import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketWriteUseCase {
  final MarketRepository _repo;

  MarketWriteUseCase(this._repo);

  Future<void> execute({
    required MarketWriteEntity entity,
  }) async {
    return _repo.submitMarket(entity: entity);
  }
}
