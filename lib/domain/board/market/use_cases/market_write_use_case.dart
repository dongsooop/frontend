import 'package:dongsoop/domain/board/market/entities/market_write_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketWriteUseCase {
  final MarketRepository repository;

  MarketWriteUseCase(this.repository);

  /// 작성 최종 서버 제출
  Future<void> execute({
    required MarketWriteEntity entity,
  }) async {
    return repository.submitMarket(entity: entity);
  }
}
