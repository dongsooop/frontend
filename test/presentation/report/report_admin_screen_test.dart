import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/report_chat_room_type.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_message_context.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/get_reports_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_dismiss_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_screen.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('세그먼트 탭을 좌우로 밀어 신고 상태를 전환한다', (tester) async {
    final repository = _FakeReportRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getReportsUseCaseProvider.overrideWithValue(
            GetReportsUseCase(repository),
          ),
          reportAdminDismissUseCaseProvider.overrideWithValue(
            ReportAdminDismissUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (_) async => false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.requestedTypes, ['UNPROCESSED']);

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(
      DefaultTabController.of(tester.element(find.byType(TabBarView))).index,
      1,
    );
    expect(repository.requestedTypes, ['UNPROCESSED', 'ACTIVE_SANCTIONS']);

    await tester.drag(find.byType(TabBarView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(
      DefaultTabController.of(tester.element(find.byType(TabBarView))).index,
      2,
    );
    expect(
      repository.requestedTypes,
      ['UNPROCESSED', 'ACTIVE_SANCTIONS', 'PROCESSED'],
    );
  });

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
          reportAdminDismissUseCaseProvider.overrideWithValue(
            ReportAdminDismissUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (report) async {
              selectedReportId = report.id;
              selectedMemberId = report.targetMemberId;
              return true;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _visitAllTabs(tester);

    expect(find.text('신고 대상 사용자'), findsOneWidget);
    expect(find.text('문제가 된 메시지'), findsOneWidget);
    expect(find.text('단체 채팅'), findsOneWidget);

    await tester.tap(find.byKey(const Key('report-admin-card-1')));
    await tester.pumpAndSettle();

    expect(find.text('신고 상세'), findsOneWidget);
    expect(find.text('단체 채팅'), findsNWidgets(2));
    expect(find.text('첫 번째 문맥'), findsOneWidget);
    expect(find.text('두 번째 문맥'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('첫 번째 문맥')).dy,
      lessThan(tester.getTopLeft(find.text('두 번째 문맥')).dy),
    );
    expect(find.text('신고 대상'), findsWidgets);
    expect(find.text('제재 검토'), findsOneWidget);
    expect(find.text('제재 없이 처리'), findsOneWidget);

    await tester.tap(find.text('제재 검토'));
    await tester.pumpAndSettle();

    expect(selectedReportId, 1);
    expect(selectedMemberId, 7);
    _expectEachFilterRequestedTwice(repository);

    await tester.tap(find.byKey(const Key('report-filter-처리 완료')));
    await tester.pumpAndSettle();
    expect(find.text('신고 #1 처리로 함께 해결됨'), findsOneWidget);
    await tester.tap(find.byKey(const Key('report-admin-card-2')));
    await tester.pumpAndSettle();

    expect(find.text('신고 #1 처리로 함께 해결됨'), findsNWidgets(2));
    expect(find.text('이 신고에 별도 제재가 생성된 것은 아닙니다.'), findsOneWidget);
    expect(find.text('처리 관리자'), findsOneWidget);
    expect(find.text('관리자'), findsOneWidget);
    expect(find.text('제재 검토'), findsNothing);
    expect(find.text('제재 없이 처리'), findsNothing);
  });

  testWidgets('미처리 메시지 신고를 확인 후 제재 없이 처리하고 목록을 갱신한다', (tester) async {
    final repository = _FakeReportRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getReportsUseCaseProvider.overrideWithValue(
            GetReportsUseCase(repository),
          ),
          reportAdminDismissUseCaseProvider.overrideWithValue(
            ReportAdminDismissUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (_) async => false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _visitAllTabs(tester);

    await tester.tap(find.byKey(const Key('report-admin-card-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-dismiss-button')));
    await tester.pumpAndSettle();

    expect(find.text('제재 없이 처리할까요?'), findsOneWidget);
    expect(repository.dismissedReportIds, isEmpty);

    await tester.tap(find.text('취소'));
    await tester.pumpAndSettle();
    expect(repository.dismissedReportIds, isEmpty);

    await tester.tap(find.byKey(const Key('report-dismiss-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('처리'));
    await tester.pumpAndSettle();

    expect(repository.dismissedReportIds, [1]);
    expect(find.text('신고 처리 완료'), findsOneWidget);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('신고 상세'), findsNothing);
    _expectEachFilterRequestedTwice(repository);
  });

  testWidgets('다른 관리자가 먼저 처리한 신고는 안내 후 목록을 갱신한다', (tester) async {
    final repository = _FakeReportRepository()
      ..dismissError = const AlreadyProcessedException('이미 처리된 신고입니다. ID : 1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getReportsUseCaseProvider.overrideWithValue(
            GetReportsUseCase(repository),
          ),
          reportAdminDismissUseCaseProvider.overrideWithValue(
            ReportAdminDismissUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (_) async => false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _visitAllTabs(tester);

    await tester.tap(find.byKey(const Key('report-admin-card-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-dismiss-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('처리'));
    await tester.pumpAndSettle();

    expect(find.text('신고 상태가 변경됐어요'), findsOneWidget);
    expect(find.text('이미 처리된 신고입니다. ID : 1'), findsWidgets);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(find.text('신고 상세'), findsNothing);
    _expectEachFilterRequestedTwice(repository);
  });

  testWidgets('대상 닉네임이 없으면 목록과 상세에 사용자 ID를 표시한다', (tester) async {
    final repository = _FakeReportRepository(
      unprocessedReport: _unprocessedReportWithoutNickname,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getReportsUseCaseProvider.overrideWithValue(
            GetReportsUseCase(repository),
          ),
          reportAdminDismissUseCaseProvider.overrideWithValue(
            ReportAdminDismissUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminScreen(
            onTapReportSanction: (_) async => false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('사용자 ID 52'), findsOneWidget);
    expect(find.text('알 수 없는 사용자'), findsNothing);

    await tester.tap(find.byKey(const Key('report-admin-card-3')));
    await tester.pumpAndSettle();

    expect(find.text('사용자 ID 52'), findsNWidgets(2));
    expect(find.text('알 수 없는 사용자'), findsNothing);
  });
}

Future<void> _visitAllTabs(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('report-filter-활성 제재')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('report-filter-처리 완료')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('report-filter-미처리')));
  await tester.pumpAndSettle();
}

void _expectEachFilterRequestedTwice(_FakeReportRepository repository) {
  for (final type in ['UNPROCESSED', 'ACTIVE_SANCTIONS', 'PROCESSED']) {
    expect(
      repository.requestedTypes.where((requested) => requested == type),
      hasLength(2),
      reason: '$type 탭이 최신화되어야 합니다.',
    );
  }
}

class _FakeReportRepository implements ReportRepository {
  int unprocessedCallCount = 0;
  final List<String> requestedTypes = [];
  final List<int> dismissedReportIds = [];
  final ReportAdminSanction unprocessedReport;
  Object? dismissError;

  _FakeReportRepository({
    this.unprocessedReport = _unprocessedReport,
  });

  @override
  Future<void> dismissReport(int reportId) async {
    dismissedReportIds.add(reportId);
    if (dismissError case final Object error) throw error;
  }

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) async {
    requestedTypes.add(type);
    if (type == 'PROCESSED') {
      return [_processedReport];
    }
    unprocessedCallCount += 1;
    return [unprocessedReport];
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
  chatRoomType: ReportChatRoomType.GROUP,
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
  resolvedByReportId: 1,
  messageContent: '처리된 메시지',
  chatRoomType: ReportChatRoomType.BLINDDATE,
  createdAt: '2026.10.15 11:00',
);

const _unprocessedReportWithoutNickname = ReportAdminSanction(
  id: 3,
  reporterNickname: '신고자',
  reportType: 'CHAT_MESSAGE',
  targetMemberId: 52,
  reportReason: 'HATE_SPEECH',
  isProcessed: false,
  messageContent: '신고된 메시지',
  chatRoomType: ReportChatRoomType.ONE_TO_ONE,
  createdAt: '2026.10.15 12:00',
);
