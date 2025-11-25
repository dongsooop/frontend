import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';

abstract class FeedbackDataSource {
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  });
}