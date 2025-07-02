import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';
import 'package:dongsoop/domain/board/market/repository/market_repository.dart';

class MarketDetailUseCase {
  final MarketRepository repository;

  MarketDetailUseCase(this.repository);

  Future<MarketDetailEntity> execute({
    required int id,
  }) {
    return repository.fetchMarketDetail(
      id: id,
    );
  }
}
