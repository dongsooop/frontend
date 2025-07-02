import 'package:dongsoop/domain/board/market/entities/market_ai_filter_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketAIFilterUseCase {
  final MarketRepository repository;

  MarketAIFilterUseCase(this.repository);

  /// 비속어 감지용 호출
  Future<void> execute({
    required MarketAIFilterEntity entity,
  }) async {
    return repository.requestMarketAI(entity: entity);
  }
}
