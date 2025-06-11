import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeSchoolUseCase {
  final NoticeRepository repository;

  NoticeSchoolUseCase(this.repository);

  Future<List<NoticeEntity>> execute({required int page}) {
    return repository.fetchSchoolNotices(page: page);
  }
}
