import 'package:dongsoop/domain/notice/reminder/repository/notice_reminder_repository.dart';

class SetNoticeReminderUseCase {
  final NoticeReminderRepository _repository;

  SetNoticeReminderUseCase(this._repository);

  Future<void> call({
    required int noticeId,
    required DateTime remindAt,
  }) {
    return _repository.upsert(
      noticeId: noticeId,
      remindAt: remindAt,
    );
  }
}
