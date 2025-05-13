import 'package:dongsoop/domain/notice/entites/notice_entity.dart';

/// 백엔드에서 내려주는 공지 데이터를 표현하는 데이터 모델
class NoticeModel {
  final int id; // 공지 id
  final DateTime create_at; // 공지 생성일자
  final String title; // 공지 제목
  final String link; // 공지 상세 링크

  NoticeModel({
    required this.id,
    required this.create_at,
    required this.title,
    required this.link,
  });

  /// JSON 데이터를 NoticeModel 객체로 변환하는 팩토리 생성자
  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'],
      create_at: DateTime.parse(json['create_at']),
      title: json['title'],
      link: json['link'],
    );
  }
}

/// NoticeModel을 도메인 계층의 NoticeEntity로 변환하는 매퍼(정의하는 객체나 함수)
extension NoticeModelMapper on NoticeModel {
  NoticeEntity toEntity() {
    return NoticeEntity(
      id: id,
      createdAt: create_at,
      title: title,
      link: link,
    );
  }
}
