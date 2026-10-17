import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/exception/message_report_exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/use_case/report_blind_date_message_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_chat_message_use_case.dart';
import 'package:dongsoop/presentation/report/message_report_state.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReportViewModel extends StateNotifier<MessageReportState> {
  final MessageReportTarget _target;
  final ReportChatMessageUseCase _reportChatMessageUseCase;
  final ReportBlindDateMessageUseCase _reportBlindDateMessageUseCase;

  bool _submitting = false;

  MessageReportViewModel({
    required MessageReportTarget target,
    required ReportChatMessageUseCase reportChatMessageUseCase,
    required ReportBlindDateMessageUseCase reportBlindDateMessageUseCase,
  })  : _target = target,
        _reportChatMessageUseCase = reportChatMessageUseCase,
        _reportBlindDateMessageUseCase = reportBlindDateMessageUseCase,
        super(const MessageReportState());

  void selectReason(ReportReason reason) {
    if (state.isSubmitting) return;
    state = state.copyWith(selectedReason: reason, clearError: true);
  }

  void updateDescription(String description) {
    if (state.isSubmitting) return;
    state = state.copyWith(description: description, clearError: true);
  }

  Future<bool> submit() async {
    if (_submitting || !state.canSubmit) return false;

    _submitting = true;
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final reason = state.selectedReason!;
      final trimmedDescription = state.description.trim();
      final description =
          trimmedDescription.isEmpty ? null : trimmedDescription;

      switch (_target) {
        case final ChatMessageReportTarget target:
          await _reportChatMessageUseCase.execute(
            ChatReportRequest(
              roomId: target.roomId,
              messageId: target.messageId,
              reason: reason,
              description: description,
            ),
          );
        case final BlindDateMessageReportTarget target:
          await _reportBlindDateMessageUseCase.execute(
            BlindDateReportRequest(
              sessionId: target.sessionId,
              messageId: target.messageId,
              reason: reason,
              description: description,
            ),
          );
      }

      return true;
    } on SessionExpiredException {
      return false;
    } on MessageReportException catch (error) {
      state = state.copyWith(errorMessage: error.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: '신고 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
      );
      return false;
    } finally {
      _submitting = false;
      state = state.copyWith(isSubmitting: false);
    }
  }
}
