abstract class NoticeReminderDataSource {
  Future<void> setReminder({
    required int noticeId,
    required DateTime remindAt,
  });

  Future<void> deleteReminder({
    required int noticeId,
  });
}
