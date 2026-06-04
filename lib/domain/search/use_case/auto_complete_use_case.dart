import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:dongsoop/domain/search/repository/search_repository.dart';

class AutocompleteUseCase {
  final SearchRepository _repository;

  const AutocompleteUseCase(this._repository);

  Future<List<String>> execute({
    required String keyword,
    required SearchBoardType boardType,
  }) {
    final k = keyword.trim();
    if (k.isEmpty) return Future.value(const <String>[]);

    return _repository.searchAuto(
      keyword: k,
      boardType: boardType,
    );
  }
}