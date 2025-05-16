import 'package:dongsoop/domain/notice/entites/notice_entity.dart';
import 'package:dongsoop/domain/notice/repositories/notice_repository.dart';

/// 공지사항 관련 비즈니스 로직을 담당하는 UseCase 클래스
/// 외부에서는 이 클래스를 통해 공지사항 목록을 가져올 수 있음
class NoticeUseCase {
  /// 공지사항 데이터를 가져오기 위한 레포지토리
  final NoticeRepository repository;

  /// 생성자에서 레포지토리를 주입받음 (의존성 주입)
  NoticeUseCase(this.repository);

  /// 공지사항 목록을 비동기로 가져오는 메서드
  /// page 번호를 받아 해당 페이지의 공지 데이터를 반환함
  Future<List<NoticeEntity>> call({required int page}) async {
    return await repository.fetchNotices(page: page);
  }
}
