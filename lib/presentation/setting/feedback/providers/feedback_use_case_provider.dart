import 'package:dongsoop/domain/feedback/use_case/feedback_csv_use_case.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_more_use_case.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_use_case.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_write_use_case.dart';
import 'package:dongsoop/presentation/setting/feedback/providers/feedback_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackWriteUseCaseProvider = Provider<FeedbackWriteUseCase>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackWriteUseCase(repository);
});

final feedbackUseCaseProvider = Provider<FeedbackUseCase>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackUseCase(repository);
});

final feedbackCsvUseCaseProvider = Provider<FeedbackCsvUseCase>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackCsvUseCase(repository);
});

final feedbackMoreUseCaseProvider = Provider<FeedbackMoreUseCase>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackMoreUseCase(repository);
});