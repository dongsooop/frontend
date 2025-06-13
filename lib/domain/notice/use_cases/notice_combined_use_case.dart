import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeCombinedUseCase {
  final NoticeRepository _repository;
  NoticeCombinedUseCase(this._repository);

  Future<List<NoticeEntity>> execute({
    required int page,
    required String? departmentType,
    bool force = false,
  }) async {
    if (departmentType == null) {
      return await _repository.fetchSchoolNotices(page: page, force: force);
    }

    final school =
        await _repository.fetchSchoolNotices(page: page, force: force);
    final department = await _repository.fetchDepartmentNotices(
      page: page,
      departmentType: departmentType,
      force: force,
    );

    final combined = [...school, ...department]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 최신순 정렬
    return combined;
  }
}
