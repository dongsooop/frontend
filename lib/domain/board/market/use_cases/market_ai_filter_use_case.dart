import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketAIFilterUseCase {
  final MarketRepository repository;

  MarketAIFilterUseCase(this.repository);

  Future<void> execute({
    required MarketAIFilterEntity entity,
  }) async {
    return repository.requestMarketAI(entity: entity);
  }
}
