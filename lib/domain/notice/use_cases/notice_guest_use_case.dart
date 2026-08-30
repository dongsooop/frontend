import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';

class NoticeGuestUseCase {
  final NoticeRepository repository;

  NoticeGuestUseCase(this.repository);

  Future<List<NoticeEntity>> execute({
    required int page,
    String? fid,
    String? deviceToken,
  }) {
    return repository.fetchGuestNotices(
      page: page,
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
