import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:dongsoop/domain/search/repository/search_repository.dart';

class SearchNoticeUseCase {
  final SearchRepository _repository;
  const SearchNoticeUseCase(this._repository);

  Future<List<SearchNoticeEntity>> searchOfficial({
    required int page,
    required String keyword,
  }) {
    return _repository.searchOfficialNotice(
      page: page,
      keyword: keyword.trim(),
    );
  }

  Future<List<SearchNoticeEntity>> searchDepartment({
    required int page,
    required String keyword,
    required String departmentName,
  }) {
    return _repository.searchDeptNotice(
      page: page,
      keyword: keyword.trim(),
      departmentName: departmentName,
    );
  }

  Future<List<SearchNoticeEntity>> searchCombined({
    required int page,
    required String keyword,
    String? departmentName,
  }) async {
    final futures = <Future<List<SearchNoticeEntity>>>[
      searchOfficial(page: page, keyword: keyword),
      if ((departmentName ?? '').isNotEmpty)
        searchDepartment(page: page, keyword: keyword, departmentName: departmentName!),
    ];

    final results = await Future.wait(futures);
    final merged = <SearchNoticeEntity>[...results.expand((e) => e)];

    merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final seen = <int>{};
    final deduped = <SearchNoticeEntity>[];
    for (final e in merged) {
      if (seen.add(e.id)) deduped.add(e);
    }
    return deduped;
  }
}