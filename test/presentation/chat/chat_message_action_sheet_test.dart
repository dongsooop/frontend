import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:dongsoop/presentation/chat/widgets/chat_message_action_sheet.dart';
import 'package:dongsoop/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canReportChatMessage', () {
    test('senderId가 현재 사용자와 다른 일반 메시지만 신고할 수 있다', () {
      expect(
        canReportChatMessage(_message, currentUserId: 1),
        isTrue,
      );
      expect(
        canReportChatMessage(_message, currentUserId: 2),
        isFalse,
      );
      expect(
        canReportChatMessage(_message, currentUserId: null),
        isFalse,
      );
    });

    test('시스템 메시지와 messageId가 없는 메시지는 신고할 수 없다', () {
      expect(
        canReportChatMessage(
          _message.copyWith(type: 'ENTER'),
          currentUserId: 1,
        ),
        isFalse,
      );
      expect(
        canReportChatMessage(
          _message.copyWith(messageId: '  '),
          currentUserId: 1,
        ),
        isFalse,
      );
    });
  });

  testWidgets('내 메시지 액션시트에는 복사만 표시한다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(
      tester,
      repository,
      message: _message,
      currentUserId: 2,
    );

    await tester.tap(find.text('메시지 메뉴 열기'));
    await tester.pumpAndSettle();

    expect(find.text('복사'), findsOneWidget);
    expect(find.text('신고'), findsNothing);
    expect(find.text('취소'), findsOneWidget);
  });

  testWidgets('복사를 선택하면 완료 안내를 표시한다', (tester) async {
    final clipboardCalls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      clipboardCalls.add(call);
      return null;
    });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final repository = _FakeReportRepository();
    await _pumpLauncher(
      tester,
      repository,
      message: _message,
      currentUserId: 2,
    );
    await tester.tap(find.text('메시지 메뉴 열기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('복사'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('메시지를 복사했습니다.'), findsOneWidget);
    expect(
        clipboardCalls,
        contains(
          isA<MethodCall>()
              .having((call) => call.method, 'method', 'Clipboard.setData')
              .having(
            (call) => call.arguments,
            'arguments',
            {'text': '테스트 메시지'},
          ),
        ));
    expect(repository.chatRequest, isNull);
  });

  testWidgets('상대 메시지 신고에 정확한 roomId와 messageId를 전달한다', (tester) async {
    final repository = _FakeReportRepository();
    await _pumpLauncher(
      tester,
      repository,
      message: _message,
      currentUserId: 1,
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

    expect(repository.chatRequest?.roomId, 'room-7');
    expect(repository.chatRequest?.messageId, 'message-9');
    expect(repository.chatRequest?.reason.name, 'SPAM');
    expect(find.text('신고가 접수되었습니다.'), findsOneWidget);
  });
}

final _message = ChatMessage(
  messageId: 'message-9',
  roomId: 'room-7',
  senderId: 2,
  content: '테스트 메시지',
  timestamp: DateTime(2026, 10, 15, 13),
  type: 'CHAT',
);

Future<void> _pumpLauncher(
  WidgetTester tester,
  _FakeReportRepository repository, {
  required ChatMessage message,
  required int? currentUserId,
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
                onPressed: () => showChatMessageActions(
                  context,
                  message: message,
                  currentUserId: currentUserId,
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
  ChatReportRequest? chatRequest;

  @override
  Future<void> dismissReport(int reportId) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    chatRequest = request;
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
