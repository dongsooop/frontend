import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('채팅 신고 UseCase가 요청을 Repository에 그대로 전달한다', () async {
    final repository = _FakeReportRepository();
    final useCase = ReportChatMessageUseCase(repository);
    final request = ChatReportRequest(
      roomId: 'room-1',
      messageId: 'message-1',
      reason: ReportReason.SPAM,
      description: '광고 도배',
    );

    await useCase.execute(request);

    expect(repository.chatRequest, same(request));
  });

  test('과팅 신고 UseCase가 요청을 Repository에 그대로 전달한다', () async {
    final repository = _FakeReportRepository();
    final useCase = ReportBlindDateMessageUseCase(repository);
    final request = BlindDateReportRequest(
      sessionId: 'session-1',
      messageId: 'message-2',
      reason: ReportReason.HATE_SPEECH,
    );

    await useCase.execute(request);

    expect(repository.blindDateRequest, same(request));
  });
}

class _FakeReportRepository implements ReportRepository {
  ChatReportRequest? chatRequest;
  BlindDateReportRequest? blindDateRequest;

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    chatRequest = request;
  }

  @override
  Future<void> reportBlindDateMessage(BlindDateReportRequest request) async {
    blindDateRequest = request;
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
