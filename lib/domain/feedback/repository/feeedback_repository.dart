import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';

abstract class FeedbackRepository {
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  });
}