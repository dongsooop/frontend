import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';

abstract class FeedbackDataSource {
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  });

  Future<FeedbackListEntity> feedbackList();

  Future<List<String>> improvementSuggestions({
    required int page,
    required int size,
  });

  Future<List<String>> featureRequests({
    required int page,
    required int size,
  });
}