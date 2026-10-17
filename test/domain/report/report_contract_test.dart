import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/enum/report_type.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('메시지 신고 요청', () {
    test('일반 채팅 신고를 API 계약에 맞게 직렬화한다', () {
      final request = ChatReportRequest(
        roomId: 'room-1',
        messageId: 'message-1',
        reason: ReportReason.SPAM,
        description: '광고 도배',
      );

      expect(request.toJson(), {
        'roomId': 'room-1',
        'messageId': 'message-1',
        'reason': 'SPAM',
        'description': '광고 도배',
      });
    });

    test('신고 설명이 없으면 description을 전송하지 않는다', () {
      final request = ChatReportRequest(
        roomId: 'room-1',
        messageId: 'message-1',
        reason: ReportReason.OTHER,
      );

      expect(request.toJson(), isNot(contains('description')));
    });

    test('과팅 신고에 sessionId와 messageId를 포함한다', () {
      final request = BlindDateReportRequest(
        sessionId: 'session-1',
        messageId: 'message-1',
        reason: ReportReason.HATE_SPEECH,
      );

      expect(request.toJson(), {
        'sessionId': 'session-1',
        'messageId': 'message-1',
        'reason': 'HATE_SPEECH',
      });
    });
  });

  group('관리자 신고 응답', () {
    final json = <String, dynamic>{
      'id': 101,
      'reporterNickname': '신고자',
      'reportType': 'BLINDDATE_MESSAGE',
      'targetId': null,
      'targetMemberId': 42,
      'targetMemberNickname': '익명2',
      'reportReason': 'HATE_SPEECH',
      'description': '욕설을 반복함',
      'isProcessed': false,
      'createdAt': '2026-10-08T21:13:40',
      'chatRoomId': 'session-1',
      'chatRoomType': 'BLINDDATE',
      'resolvedByReportId': 99,
      'messageId': 'message-1',
      'messageContent': '신고된 메시지',
      'messageSentAt': '2026-10-08T21:12:58',
      'messageContext': [
        {
          'senderId': 7,
          'content': '첫 번째',
          'sentAt': '2026-10-08T21:12:30',
        },
        {
          'senderId': 42,
          'content': '두 번째',
          'sentAt': '2026-10-08T21:12:40',
        },
      ],
    };

    test('메시지 신고는 targetId가 null이어도 파싱된다', () {
      final response = ReportAdminSanctionResponse.fromJson(json);

      expect(response.targetId, isNull);
      expect(response.messageContext, hasLength(2));
      expect(response.messageContext!.first.senderId, 7);
    });

    test('메시지 문맥의 서버 순서를 그대로 유지한다', () {
      final response = ReportAdminSanctionResponse.fromJson(json);

      expect(
        response.messageContext!.map((context) => context.content),
        ['첫 번째', '두 번째'],
      );
    });

    test('응답을 화면용 모델로 변환한다', () {
      final report = ReportAdminSanction.fromEntity(
        ReportAdminSanctionResponse.fromJson(json),
      );

      expect(report.targetId, isNull);
      expect(report.isProcessed, isFalse);
      expect(report.chatRoomId, 'session-1');
      expect(report.chatRoomType, ReportChatRoomType.BLINDDATE);
      expect(report.resolvedByReportId, 99);
      expect(report.relatedResolutionLabel, '신고 #99 처리로 함께 해결됨');
      expect(report.messageId, 'message-1');
      expect(report.messageContext.map((context) => context.content), [
        '첫 번째',
        '두 번째',
      ]);
    });

    test('신규 필드가 없는 기존 신고 응답도 파싱된다', () {
      final legacyJson = Map<String, dynamic>.from(json)
        ..remove('chatRoomType')
        ..remove('resolvedByReportId');

      final response = ReportAdminSanctionResponse.fromJson(legacyJson);
      final report = ReportAdminSanction.fromEntity(response);

      expect(response.chatRoomType, isNull);
      expect(response.resolvedByReportId, isNull);
      expect(report.chatRoomType, isNull);
      expect(report.resolvedByReportId, isNull);
      expect(report.relatedResolutionLabel, isNull);
    });

    test('알 수 없는 채팅방 유형은 UNKNOWN으로 파싱된다', () {
      final unknownJson = Map<String, dynamic>.from(json)
        ..['chatRoomType'] = 'NEW_CHAT_ROOM';

      final response = ReportAdminSanctionResponse.fromJson(unknownJson);

      expect(response.chatRoomType, ReportChatRoomType.UNKNOWN);
    });

    test('지원하는 채팅방 유형을 모두 파싱한다', () {
      const types = {
        'ONE_TO_ONE': ReportChatRoomType.ONE_TO_ONE,
        'GROUP': ReportChatRoomType.GROUP,
        'CONTACT': ReportChatRoomType.CONTACT,
        'BLINDDATE': ReportChatRoomType.BLINDDATE,
      };

      for (final entry in types.entries) {
        final typedJson = Map<String, dynamic>.from(json)
          ..['chatRoomType'] = entry.key;

        final response = ReportAdminSanctionResponse.fromJson(typedJson);

        expect(response.chatRoomType, entry.value);
      }
    });

    test('대상 닉네임이 없으면 사용자 ID를 표시한다', () {
      const report = ReportAdminSanction(
        id: 101,
        reporterNickname: '신고자',
        reportType: 'CHAT_MESSAGE',
        targetMemberId: 42,
        reportReason: 'HATE_SPEECH',
        isProcessed: false,
        createdAt: '2026.10.15 10:00',
      );

      expect(report.targetMemberLabel, '사용자 ID 42');
    });

    test('공백 닉네임도 누락으로 보고 사용자 ID를 표시한다', () {
      const report = ReportAdminSanction(
        id: 101,
        reporterNickname: '신고자',
        reportType: 'CHAT_MESSAGE',
        targetMemberId: 42,
        targetMemberNickname: '   ',
        reportReason: 'HATE_SPEECH',
        isProcessed: false,
        createdAt: '2026.10.15 10:00',
      );

      expect(report.targetMemberLabel, '사용자 ID 42');
    });
  });

  group('enum 계약', () {
    test('채팅과 과팅 신고 유형을 변환한다', () {
      expect(
        ReportType.fromString('CHAT_MESSAGE'),
        ReportType.CHAT_MESSAGE,
      );
      expect(
        ReportType.fromString('BLINDDATE_MESSAGE'),
        ReportType.BLINDDATE_MESSAGE,
      );
    });

    test('기존 게시판·회원 신고 유형을 지원하지 않는다', () {
      expect(ReportType.fromString('MEMBER'), ReportType.UNKNOWN);
      expect(ReportType.fromString('PROJECT_BOARD'), ReportType.UNKNOWN);
    });

    test('혐오 발언과 채팅방 추방 문자열을 변환한다', () {
      expect(
        ReportReason.fromString('HATE_SPEECH'),
        ReportReason.HATE_SPEECH,
      );
      expect(
        SanctionType.tryFromString('CHAT_KICK'),
        SanctionType.CHAT_KICK,
      );
      expect(
        SanctionType.tryFromString('CONTENT_DELETION'),
        isNull,
      );
    });
  });

  test('선택 제재 필드가 null이면 JSON에서 제외한다', () {
    final request = ReportAdminSanctionRequest(
      reportId: 101,
      targetMemberId: 42,
      sanctionType: SanctionType.WARNING,
    );

    expect(request.toJson(), {
      'reportId': 101,
      'targetMemberId': 42,
      'sanctionType': 'WARNING',
    });
  });

  test('일시정지 종료 시각은 KST 벽시계의 초 단위 문자열로 직렬화한다', () {
    final request = ReportAdminSanctionRequest(
      reportId: 101,
      targetMemberId: 42,
      sanctionType: SanctionType.TEMPORARY_BAN,
      sanctionEndAt: DateTime(2026, 10, 15, 23, 59, 59, 123),
    );

    expect(
      request.toJson()['sanctionEndAt'],
      '2026-10-15T23:59:59',
    );
  });
}
