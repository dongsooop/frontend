import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:dongsoop/presentation/chat/widgets/blind_bubble.dart';
import 'package:dongsoop/presentation/chat/widgets/blind_date_message_action_sheet.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canReportBlindDateMessage', () {
    test('다른 사용자가 보낸 USER 메시지만 신고할 수 있다', () {
      expect(
        canReportBlindDateMessage(
          _message,
          currentUserId: 54,
          sessionId: 'session-11',
        ),
        isTrue,
      );
      expect(
        canReportBlindDateMessage(
          _message,
          currentUserId: 52,
          sessionId: 'session-11',
        ),
        isFalse,
      );
      expect(
        canReportBlindDateMessage(
          _message,
          currentUserId: null,
          sessionId: 'session-11',
        ),
        isFalse,
      );
    });

    test('시스템 메시지나 식별자가 없는 메시지는 신고할 수 없다', () {
      expect(
        canReportBlindDateMessage(
          _message.copyWith(type: 'SYSTEM'),
          currentUserId: 54,
          sessionId: 'session-11',
        ),
        isFalse,
      );
      expect(
        canReportBlindDateMessage(
          _message.copyWith(messageId: '  '),
          currentUserId: 54,
          sessionId: 'session-11',
        ),
        isFalse,
      );
      expect(
        canReportBlindDateMessage(
          _message,
          currentUserId: 54,
          sessionId: null,
        ),
        isFalse,
      );
    });
  });

  testWidgets('과팅 USER 말풍선을 길게 누르면 메시지 메뉴 콜백을 실행한다', (tester) async {
    var longPressCount = 0;
    await tester.pumpWidget(
      _app(
        BlindBubble(
          '익명2',
          '신고할 메시지',
          '오후 1:00',
          false,
          'USER',
          onLongPress: () => longPressCount += 1,
        ),
      ),
    );

    await tester.longPress(find.text('신고할 메시지'));
    await tester.pump();

    expect(longPressCount, 1);
  });

  testWidgets('과팅 SYSTEM 말풍선은 메시지 메뉴를 열지 않는다', (tester) async {
    var longPressCount = 0;
    await tester.pumpWidget(
      _app(
        BlindBubble(
          '동냥이',
          '시스템 안내',
          '오후 1:00',
          false,
          'SYSTEM',
          onLongPress: () => longPressCount += 1,
        ),
      ),
    );

    await tester.longPress(find.text('시스템 안내'));
    await tester.pump();

    expect(longPressCount, 0);
  });

  testWidgets('내 과팅 메시지 액션시트에는 복사만 표시한다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(
      tester,
      repository,
      message: _message,
      currentUserId: 52,
      sessionId: 'session-11',
    );

    await tester.tap(find.text('메시지 메뉴 열기'));
    await tester.pumpAndSettle();

    expect(find.text('복사'), findsOneWidget);
    expect(find.text('신고'), findsNothing);
    expect(find.text('취소'), findsOneWidget);
  });

  testWidgets('상대 과팅 메시지 신고에 정확한 sessionId와 messageId를 전달한다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(
      tester,
      repository,
      message: _message,
      currentUserId: 54,
      sessionId: 'session-11',
    );
    await tester.tap(find.text('메시지 메뉴 열기'));
    await tester.pumpAndSettle();

    expect(find.text('복사'), findsOneWidget);
    expect(find.text('신고'), findsOneWidget);

    await tester.tap(find.text('신고'));
    await tester.pumpAndSettle();
    expect(find.text('메시지 신고'), findsOneWidget);

    await tester.tap(find.text('스팸/도배'));
    await tester.pump();
    await tester.tap(find.text('신고하기'));
    await tester.pumpAndSettle();

    expect(repository.blindDateRequest?.sessionId, 'session-11');
    expect(repository.blindDateRequest?.messageId, 'message-17');
    expect(repository.blindDateRequest?.reason.name, 'SPAM');
    expect(find.text('신고가 접수되었습니다.'), findsOneWidget);
  });
}

final _message = BlindDateMessage(
  messageId: 'message-17',
  message: '테스트 메시지',
  memberId: 52,
  name: '익명2',
  sendAt: DateTime(2026, 10, 15, 13),
  type: 'USER',
);

Widget _app(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

Future<void> _pumpLauncher(
  WidgetTester tester,
  _FakeReportRepository repository, {
  required BlindDateMessage message,
  required int? currentUserId,
  required String? sessionId,
}) async {
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
                onPressed: () => showBlindDateMessageActions(
                  context,
                  message: message,
                  currentUserId: currentUserId,
                  sessionId: sessionId,
                ),
                child: const Text('메시지 메뉴 열기'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _FakeReportRepository implements ReportRepository {
  BlindDateReportRequest? blindDateRequest;

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) async {
    blindDateRequest = request;
  }

  @override
  Future<void> reportChatMessage(ChatReportRequest request) {
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
