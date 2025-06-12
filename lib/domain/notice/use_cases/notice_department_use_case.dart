import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeDepartmentUseCase {
  final NoticeRepository repository;

  NoticeDepartmentUseCase(this.repository);

  Future<List<NoticeEntity>> execute({
    required int page,
    required String departmentType,
  }) {
    return repository.fetchDepartmentNotices(
        page: page, departmentType: departmentType);
  }
}
