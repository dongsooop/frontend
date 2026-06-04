import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/search/entity/search_market_entity.dart';
import 'package:dongsoop/domain/search/repository/search_repository.dart';
import 'package:dongsoop/domain/search/config/search_config.dart';

class SearchMarketUseCase {
  final SearchRepository _repository;
  final SearchConfig _config;

  const SearchMarketUseCase(this._repository, this._config);

  int get pageSize => _config.pageSize;
  String get defaultSort => _config.defaultSort;

  Future<List<SearchMarketEntity>> execute({
    required int page,
    required String keyword,
    required List<MarketType> types,
  }) {
    return _repository.searchMarket(
      page: page,
      keyword: keyword.trim(),
      types: types,
      size: _config.pageSize,
      sort: _config.defaultSort,
    );
  }
}