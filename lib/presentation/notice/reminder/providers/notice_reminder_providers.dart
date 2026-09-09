import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source.dart';
import 'package:dongsoop/data/notice/reminder/data_sources/notice_reminder_data_source_impl.dart';
import 'package:dongsoop/data/notice/reminder/repository/notice_reminder_repository_impl.dart';
import 'package:dongsoop/domain/notice/reminder/repository/notice_reminder_repository.dart';
import 'package:dongsoop/domain/notice/reminder/use_cases/set_notice_reminder_use_case.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noticeReminderDataSourceProvider =
    Provider<NoticeReminderDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  final getFidUseCase = ref.watch(getFidUseCaseProvider);
  final getFcmTokenUseCase = ref.watch(getFcmTokenUseCaseProvider);

  return NoticeReminderDataSourceImpl(
    plainDio,
    getFidUseCase,
    getFcmTokenUseCase,
  );
});

final noticeReminderRepositoryProvider =
    Provider<NoticeReminderRepository>((ref) {
  final dataSource = ref.watch(noticeReminderDataSourceProvider);
  return NoticeReminderRepositoryImpl(dataSource);
});

final setNoticeReminderUseCaseProvider =
    Provider<SetNoticeReminderUseCase>((ref) {
  final repository = ref.watch(noticeReminderRepositoryProvider);
  return SetNoticeReminderUseCase(repository);
});
