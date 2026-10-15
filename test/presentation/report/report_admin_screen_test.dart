import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_message_context.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/get_reports_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_screen.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('신고 메시지와 문맥을 보여주고 미처리 신고만 제재 검토로 연결한다', (tester) async {
    final repository = _FakeReportRepository();
    int? selectedReportId;
    int? selectedMemberId;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getReportsUseCaseProvider.overrideWithValue(
            GetReportsUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (reportId, targetMemberId) {
              selectedReportId = reportId;
              selectedMemberId = targetMemberId;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('신고 대상 사용자'), findsOneWidget);
    expect(find.text('문제가 된 메시지'), findsOneWidget);

    await tester.tap(find.byKey(const Key('report-admin-card-1')));
    await tester.pumpAndSettle();

    expect(find.text('신고 상세'), findsOneWidget);
    expect(find.text('첫 번째 문맥'), findsOneWidget);
    expect(find.text('두 번째 문맥'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('첫 번째 문맥')).dy,
      lessThan(tester.getTopLeft(find.text('두 번째 문맥')).dy),
    );
    expect(find.text('신고 대상'), findsWidgets);
    expect(find.text('제재 검토'), findsOneWidget);

    await tester.tap(find.text('제재 검토'));
    await tester.pumpAndSettle();

    expect(selectedReportId, 1);
    expect(selectedMemberId, 7);

    await tester.tap(find.byKey(const Key('report-filter-처리 완료')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-admin-card-2')));
    await tester.pumpAndSettle();

    expect(find.text('처리 관리자'), findsOneWidget);
    expect(find.text('관리자'), findsOneWidget);
    expect(find.text('제재 검토'), findsNothing);
  });
}

class _FakeReportRepository implements ReportRepository {
  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) async {
    if (type == 'PROCESSED') {
      return [_processedReport];
    }
    return [_unprocessedReport];
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() {
    throw UnimplementedError();
  }

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportChatMessage(ChatReportRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) {
    throw UnimplementedError();
  }
}

const _unprocessedReport = ReportAdminSanction(
  id: 1,
  reporterNickname: '신고자',
  reportType: 'CHAT_MESSAGE',
  targetMemberId: 7,
  targetMemberNickname: '신고 대상 사용자',
  reportReason: 'HATE_SPEECH',
  description: '반복적인 비방입니다.',
  isProcessed: false,
  chatRoomId: 'room-1',
  messageId: 'message-1',
  messageContent: '문제가 된 메시지',
  messageSentAt: '2026.10.15 09:59',
  messageContext: [
    ReportMessageContext(
      senderId: 3,
      content: '첫 번째 문맥',
      sentAt: '2026.10.15 09:58',
    ),
    ReportMessageContext(
      senderId: 7,
      content: '두 번째 문맥',
      sentAt: '2026.10.15 09:59',
    ),
  ],
  createdAt: '2026.10.15 10:00',
);

const _processedReport = ReportAdminSanction(
  id: 2,
  reporterNickname: '신고자',
  reportType: 'BLINDDATE_MESSAGE',
  targetMemberId: 8,
  targetMemberNickname: '처리된 사용자',
  reportReason: 'SPAM',
  isProcessed: true,
  adminNickname: '관리자',
  sanctionType: 'WARNING',
  sanctionReason: '운영 정책 위반',
  messageContent: '처리된 메시지',
  createdAt: '2026.10.15 11:00',
);
