import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketDeleteUseCase {
  final MarketRepository _repo;

  MarketDeleteUseCase(this._repo);

  Future<void> execute({
    required int marketId,
  }) async {
    return _repo.deleteMarket(marketId: marketId);
  }
}
