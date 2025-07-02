import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketCompleteUseCase {
  final MarketRepository _repo;

  MarketCompleteUseCase(this._repo);

  Future<void> execute({
    required int marketId,
  }) async {
    return _repo.completeMarket(marketId: marketId);
  }
}
