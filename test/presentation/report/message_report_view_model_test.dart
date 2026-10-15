import 'dart:async';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/exception/message_report_exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:dongsoop/presentation/report/message_report_view_model.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageReportViewModel', () {
    test('사유를 선택해야 제출할 수 있다', () {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );

      expect(viewModel.state.canSubmit, isFalse);

      viewModel.selectReason(ReportReason.SPAM);

      expect(viewModel.state.canSubmit, isTrue);
    });

    test('채팅 신고 요청에 대상과 작성 내용을 전달한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.SPAM);
      viewModel.updateDescription('  광고 도배  ');

      final success = await viewModel.submit();

      expect(success, isTrue);
      expect(repository.chatRequest?.roomId, 'room-1');
      expect(repository.chatRequest?.messageId, 'message-1');
      expect(repository.chatRequest?.reason, ReportReason.SPAM);
      expect(repository.chatRequest?.description, '광고 도배');
    });

    test('공백뿐인 설명은 null로 변환한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.OTHER);
      viewModel.updateDescription('   ');

      await viewModel.submit();

      expect(repository.chatRequest?.description, isNull);
    });

    test('과팅 신고 요청에 sessionId와 messageId를 전달한다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(
        repository,
        const BlindDateMessageReportTarget(
          sessionId: 'session-1',
          messageId: 'message-2',
        ),
      );
      viewModel.selectReason(ReportReason.HATE_SPEECH);

      final success = await viewModel.submit();

      expect(success, isTrue);
      expect(repository.blindDateRequest?.sessionId, 'session-1');
      expect(repository.blindDateRequest?.messageId, 'message-2');
      expect(repository.blindDateRequest?.reason, ReportReason.HATE_SPEECH);
    });

    test('500자를 초과한 설명은 제출하지 않는다', () async {
      final repository = _FakeReportRepository();
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.OTHER);
      viewModel.updateDescription(List.filled(501, 'a').join());

      final success = await viewModel.submit();

      expect(success, isFalse);
      expect(repository.chatCallCount, 0);
    });

    test('제출 중 중복 호출을 차단한다', () async {
      final repository = _FakeReportRepository();
      final completer = Completer<void>();
      repository.pendingSubmission = completer;
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.FRAUD);

      final firstSubmission = viewModel.submit();
      final secondResult = await viewModel.submit();

      expect(secondResult, isFalse);
      expect(repository.chatCallCount, 1);
      expect(viewModel.state.isSubmitting, isTrue);

      completer.complete();
      expect(await firstSubmission, isTrue);
      expect(viewModel.state.isSubmitting, isFalse);
    });

    test('서버 신고 오류 문구를 표시하고 다시 제출할 수 있다', () async {
      final repository = _FakeReportRepository()
        ..error = const MessageReportException(
          failure: MessageReportFailure.duplicate,
          message: '이미 신고한 메시지입니다.',
          statusCode: 409,
        );
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.SPAM);

      expect(await viewModel.submit(), isFalse);
      expect(viewModel.state.errorMessage, '이미 신고한 메시지입니다.');
      expect(viewModel.state.isSubmitting, isFalse);

      repository.error = null;

      expect(await viewModel.submit(), isTrue);
      expect(viewModel.state.errorMessage, isNull);
      expect(repository.chatCallCount, 2);
    });

    test('세션 만료는 일반 신고 오류로 표시하지 않는다', () async {
      final repository = _FakeReportRepository()
        ..error = const SessionExpiredException();
      final viewModel = _viewModel(
        repository,
        const ChatMessageReportTarget(
          roomId: 'room-1',
          messageId: 'message-1',
        ),
      );
      viewModel.selectReason(ReportReason.SPAM);

      expect(await viewModel.submit(), isFalse);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.isSubmitting, isFalse);
    });
  });
}

MessageReportViewModel _viewModel(
  _FakeReportRepository repository,
  MessageReportTarget target,
) {
  return MessageReportViewModel(
    target: target,
    reportChatMessageUseCase: ReportChatMessageUseCase(repository),
    reportBlindDateMessageUseCase: ReportBlindDateMessageUseCase(repository),
  );
}

class _FakeReportRepository implements ReportRepository {
  ChatReportRequest? chatRequest;
  BlindDateReportRequest? blindDateRequest;
  Object? error;
  Completer<void>? pendingSubmission;
  int chatCallCount = 0;
  int blindDateCallCount = 0;

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    chatCallCount += 1;
    chatRequest = request;
    if (error case final Object submissionError) throw submissionError;
    await pendingSubmission?.future;
  }

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) async {
    blindDateCallCount += 1;
    blindDateRequest = request;
    if (error case final Object submissionError) throw submissionError;
    await pendingSubmission?.future;
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
