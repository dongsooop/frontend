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
      final result = (tab == NoticeTab.all || tab == NoticeTab.school)
          ? school
          : <NoticeEntity>[];
      result.sort((a, b) {
        final dateCompare = b.createdAt.compareTo(a.createdAt);
        if (dateCompare != 0) return dateCompare;
        return a.title.compareTo(b.title);
      });
      return result;
    }

    final department = await repository.fetchDepartmentNotices(
      page: page,
      departmentType: departmentType,
    );

    final result = switch (tab) {
      NoticeTab.all => [...school, ...department],
      NoticeTab.school => school,
      NoticeTab.department => department,
    };

    result.sort((a, b) {
      final dateCompare = b.createdAt.compareTo(a.createdAt);
      if (dateCompare != 0) return dateCompare;
      return a.title.compareTo(b.title);
    });

    return result;
  }
}
