import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackMoreUseCase {
  final FeedbackRepository repository;

  FeedbackMoreUseCase(this.repository);

  Future<List<String>> execute(FeedbackType type)
  {
    switch (type) {
      case FeedbackType.improvement:
        return repository.improvementSuggestions();
      case FeedbackType.featureRequest:
        return repository.featureRequests();
    }
  }
}