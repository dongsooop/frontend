import 'package:dongsoop/domain/notice/entites/notice_entity.dart';

/// 공지사항 데이터를 가져오기 위한 Repository 추상 클래스
/// 데이터 소스(API, 로컬 DB 등)와 무관하게 일관된 인터페이스를 제공
/// 실제 구현체는 data 계층에서 작성 (예: NoticeRepositoryImpl)
abstract class NoticeRepository {
  /// 공지사항 목록을 비동기로 가져오는 메서드
  /// page 번호를 전달받아 페이징된 데이터를 가져옴
  Future<List<NoticeEntity>> fetchNotices({required int page});
}
