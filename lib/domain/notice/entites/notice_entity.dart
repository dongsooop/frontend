/// 도메인 계층에서 사용하는 공지사항 엔티티
/// 앱의 비즈니스 로직에서 사용하는 순수 데이터 구조
/// 외부(API, DB 등)와는 분리되어 있음
class NoticeEntity {
  // 공지 고유 ID
  final int id;

  // 공지 생성 일자
  final DateTime createdAt;

  // 공지 제목
  final String title;

  // 공지 상세 링크 (웹뷰 연결용)
  final String link;

  // 생성자
  NoticeEntity({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.link,
  });
}
