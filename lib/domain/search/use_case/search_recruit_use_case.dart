import 'package:dongsoop/domain/search/repository/search_repository.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/config/search_config.dart';

class SearchRecruitUseCase {
  final SearchRepository _repository;
  final SearchConfig _config;

  const SearchRecruitUseCase(this._repository, this._config);

  int get pageSize => _config.pageSize;
  String get defaultSort => _config.defaultSort;

  Future<List<SearchRecruitEntity>> execute({
    required int page,
    required String keyword,
    required RecruitType type,
    required String departmentName,
  }) {
    return _repository.searchRecruit(
      page: page,
      keyword: keyword.trim(),
      type: type,
      departmentName: departmentName.trim(),
      size: _config.pageSize,
      sort: _config.defaultSort,
    );
  }
}