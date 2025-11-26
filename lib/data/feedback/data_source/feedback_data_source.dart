import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';

abstract class FeedbackDataSource {
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  });

  Future<FeedbackListEntity> feedbackList();

  Future<List<String>> improvementSuggestions();

  Future<List<String>> featureRequests();
}