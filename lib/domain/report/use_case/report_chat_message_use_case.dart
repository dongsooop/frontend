import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/repository/report_repository.dart';

class ReportChatMessageUseCase {
  final ReportRepository _reportRepository;

  const ReportChatMessageUseCase(this._reportRepository);

  Future<void> execute(ChatReportRequest request) async {
    await _reportRepository.reportChatMessage(request);
  }
}
