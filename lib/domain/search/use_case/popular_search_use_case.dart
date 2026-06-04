import 'package:dongsoop/domain/search/repository/search_repository.dart';

class PopularSearchUseCase {
  final SearchRepository _repository;

  const PopularSearchUseCase(this._repository);

  Future<List<String>> execute() {
    return _repository.searchPopular();
  }
}