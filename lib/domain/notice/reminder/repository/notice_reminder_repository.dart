abstract class NoticeReminderRepository {
  Future<void> upsert({
    required int noticeId,
    required DateTime remindAt,
  });

  Future<void> delete({
    required int noticeId,
  });
}
