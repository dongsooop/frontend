import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/repositories/notice_repository.dart';

enum NoticeTab { all, school, department }

class NoticeUseCase {
  final NoticeRepository repository;
  NoticeUseCase(this.repository);

  Future<List<NoticeEntity>> call({
    required int page,
    required NoticeTab tab,
    required String? departmentType,
  }) async {
    final school = await repository.fetchSchoolNotices(page: page);

    if (departmentType == null) {
      return (tab == NoticeTab.all || tab == NoticeTab.school) ? school : [];
    }

    final department = await repository.fetchDepartmentNotices(
      page: page,
      departmentType: departmentType,
    );

    return switch (tab) {
      NoticeTab.all => [...school, ...department]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      NoticeTab.school => school,
      NoticeTab.department => department,
    };
  }
}
