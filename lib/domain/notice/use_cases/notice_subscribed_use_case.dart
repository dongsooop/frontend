import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeSubscribedUseCase {
  final NoticeRepository repository;

  NoticeSubscribedUseCase(this.repository);

  Future<List<NoticeEntity>> execute({
    required int page,
    String? fid,
    String? deviceToken,
  }) {
    return repository.fetchSubscribedNotices(
      page: page,
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
