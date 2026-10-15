import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_admin_sanction_write_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_screen.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('경고는 선택 사유 없이 확인 후 제출하고 성공 결과를 반환한다', (tester) async {
    final repository = _FakeReportRepository();
    bool? routeResult;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportAdminSanctionWriteUseCaseProvider.overrideWithValue(
            ReportAdminSanctionWriteUseCase(repository),
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  key: const Key('open-sanction-screen'),
                  onPressed: () async {
                    routeResult = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => ReportAdminSanctionScreen(
                          report: _report,
                        ),
                      ),
                    );
                  },
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('open-sanction-screen')));
    await tester.pumpAndSettle();

    expect(find.text('신고 대상 사용자'), findsOneWidget);
    expect(find.textContaining('채팅 메시지'), findsOneWidget);
    expect(_submitButton(tester).onPressed, isNull);

    await tester.tap(find.byKey(const Key('sanction-type-field')));
    await tester.pumpAndSettle();

    expect(find.text('경고'), findsOneWidget);
    expect(find.text('일시정지'), findsOneWidget);
    expect(find.text('영구정지'), findsOneWidget);
    expect(find.text('채팅방 추방'), findsNothing);

    await tester.tap(find.byKey(const Key('sanction-type-WARNING')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sanction-end-at-field')), findsNothing);
    expect(_submitButton(tester).onPressed, isNotNull);

    await tester.tap(find.text('제재 적용'));
    await tester.pumpAndSettle();
    expect(find.text('제재를 적용할까요?'), findsOneWidget);

    await tester.tap(find.text('적용'));
    await tester.pumpAndSettle();
    expect(find.text('제재 완료'), findsOneWidget);

    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    expect(routeResult, isTrue);
    expect(repository.request?.reportId, 101);
    expect(repository.request?.targetMemberId, 42);
    expect(repository.request?.sanctionReason, isNull);
    expect(repository.request?.sanctionEndAt, isNull);
  });

  testWidgets('일시정지만 종료 시각을 필수로 요구한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reportAdminSanctionWriteUseCaseProvider.overrideWithValue(
            ReportAdminSanctionWriteUseCase(_FakeReportRepository()),
          ),
        ],
        child: MaterialApp(
          home: ReportAdminSanctionScreen(report: _report),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('sanction-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sanction-type-TEMPORARY_BAN')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sanction-end-at-field')), findsOneWidget);
    expect(_submitButton(tester).onPressed, isNull);

    await tester.tap(find.byKey(const Key('sanction-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sanction-type-PERMANENT_BAN')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sanction-end-at-field')), findsNothing);
    expect(_submitButton(tester).onPressed, isNotNull);
  });
}

ElevatedButton _submitButton(WidgetTester tester) {
  return tester.widget<ElevatedButton>(
    find.widgetWithText(ElevatedButton, '제재 적용'),
  );
}

class _FakeReportRepository implements ReportRepository {
  ReportAdminSanctionRequest? request;

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    this.request = request;
  }

  @override
  Future<ReportSanctionResponse?> getSanctionStatus() {
    throw UnimplementedError();
  }

  @override
  Future<List<ReportAdminSanction>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) {
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
}

const _report = ReportAdminSanction(
  id: 101,
  reporterNickname: '신고자',
  reportType: 'CHAT_MESSAGE',
  targetMemberId: 42,
  targetMemberNickname: '신고 대상 사용자',
  reportReason: 'HATE_SPEECH',
  isProcessed: false,
  messageContent: '문제가 된 메시지',
  createdAt: '2026.10.15 12:00',
);
