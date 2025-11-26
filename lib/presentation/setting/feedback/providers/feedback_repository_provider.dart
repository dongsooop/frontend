import 'package:dongsoop/data/feedback/repository/feedback_repository_impl.dart';
import 'package:dongsoop/presentation/setting/feedback/providers/feedback_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackRepositoryProvider = Provider(
      (ref) => FeedbackRepositoryImpl(ref.watch(feedbackDataSourceProvider)),
);