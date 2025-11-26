import 'package:dongsoop/data/feedback/data_source/feedback_data_source_impl.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final feedbackDataSourceProvider = Provider((ref) => FeedbackDataSourceImpl(
    ref.watch(plainDioProvider),
    ref.watch(authDioProvider),
  ),
);
