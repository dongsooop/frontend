import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketContactUseCase {
  final MarketRepository _repo;

  MarketContactUseCase(this._repo);

  Future<String> execute({
    required int marketId,
  }) async {
    return _repo.contactMarket(marketId: marketId);
  }
}
