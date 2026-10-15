import 'dart:async';

import 'package:dongsoop/core/presentation/components/common_text_form_field.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/domain/report/exception/message_report_exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:dongsoop/presentation/report/widgets/message_report_bottom_sheet.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('신고 사유 7개와 500자 설명 입력창을 표시한다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(tester, repository);

    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();

    expect(find.text('메시지 신고'), findsOneWidget);
    expect(find.text('스팸/도배'), findsOneWidget);
    expect(find.text('부적절한 내용'), findsOneWidget);
    expect(find.text('혐오 발언'), findsOneWidget);
    expect(find.text('사기/허위 정보'), findsOneWidget);
    expect(find.text('개인정보 침해'), findsOneWidget);
    expect(find.text('저작권 침해'), findsOneWidget);
    expect(find.text('기타'), findsOneWidget);
    expect(
      tester
          .widget<CommonTextFormField>(find.byType(CommonTextFormField))
          .maxLength,
      500,
    );
  });

  testWidgets('사유를 선택하기 전에는 신고 버튼이 비활성화된다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(tester, repository);
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<PrimaryBottomButton>(find.byType(PrimaryBottomButton))
          .isEnabled,
      isFalse,
    );

    await tester.tap(find.text('스팸/도배'));
    await tester.pump();

    expect(
      tester
          .widget<PrimaryBottomButton>(find.byType(PrimaryBottomButton))
          .isEnabled,
      isTrue,
    );
  });

  testWidgets('신고에 성공하면 요청을 전달하고 true로 바텀시트를 닫는다', (tester) async {
    final repository = _FakeReportRepository();
    final result = _SheetResult();
    await _pumpLauncher(tester, repository, result: result);
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('혐오 발언'));
    await tester.enterText(find.byType(TextFormField), '  반복적인 욕설  ');

    await tester.tap(find.text('신고하기'));
    await tester.pumpAndSettle();

    expect(find.text('메시지 신고'), findsNothing);
    expect(result.value, isTrue);
    expect(repository.chatRequest?.reason.name, 'HATE_SPEECH');
    expect(repository.chatRequest?.description, '반복적인 욕설');
  });

  testWidgets('신고에 실패하면 바텀시트를 유지하고 서버 메시지를 표시한다', (tester) async {
    final repository = _FakeReportRepository()
      ..error = const MessageReportException(
        failure: MessageReportFailure.duplicate,
        message: '이미 신고한 메시지입니다.',
        statusCode: 409,
      );
    await _pumpLauncher(tester, repository);
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('스팸/도배'));
    await tester.pump();

    await tester.tap(find.text('신고하기'));
    await tester.pumpAndSettle();

    expect(find.text('메시지 신고'), findsOneWidget);
    expect(find.text('이미 신고한 메시지입니다.'), findsOneWidget);
    expect(find.byKey(const Key('message-report-error')), findsOneWidget);
  });

  testWidgets('제출 중에는 로딩을 표시하고 중복 제출을 차단한다', (tester) async {
    final repository = _FakeReportRepository();
    final completer = Completer<void>();
    repository.pendingSubmission = completer;
    await _pumpLauncher(tester, repository);
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('사기/허위 정보'));
    await tester.pump();

    await tester.tap(find.text('신고하기'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(repository.chatCallCount, 1);

    await tester.tap(find.byType(PrimaryBottomButton));
    await tester.pump();
    expect(repository.chatCallCount, 1);

    completer.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('바텀시트를 닫았다가 다시 열면 작성 상태가 초기화된다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(tester, repository);
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('기타'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('기타'));
    await tester.pump();

    expect(
      tester
          .widget<PrimaryBottomButton>(find.byType(PrimaryBottomButton))
          .isEnabled,
      isTrue,
    );

    await tester.tap(find.byTooltip('닫기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('신고 작성 열기'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<PrimaryBottomButton>(find.byType(PrimaryBottomButton))
          .isEnabled,
      isFalse,
    );
  });
}

Future<void> _pumpLauncher(
  WidgetTester tester,
  _FakeReportRepository repository, {
  _SheetResult? result,
}) async {
  const target = ChatMessageReportTarget(
    roomId: 'room-1',
    messageId: 'message-1',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        reportChatMessageUseCaseProvider.overrideWithValue(
          ReportChatMessageUseCase(repository),
        ),
        reportBlindDateMessageUseCaseProvider.overrideWithValue(
          ReportBlindDateMessageUseCase(repository),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  final sheetResult = await MessageReportBottomSheet.show(
                    context,
                    target: target,
                  );
                  if (result != null) result.value = sheetResult;
                },
                child: const Text('신고 작성 열기'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SheetResult {
  bool? value;
}

class _FakeReportRepository implements ReportRepository {
  ChatReportRequest? chatRequest;
  Object? error;
  Completer<void>? pendingSubmission;
  int chatCallCount = 0;

  @override
  Future<void> dismissReport(int reportId) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    chatCallCount += 1;
    chatRequest = request;
    if (error case final Object submissionError) throw submissionError;
    await pendingSubmission?.future;
  }

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) {
    throw UnimplementedError();
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
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) {
    throw UnimplementedError();
  }
}
