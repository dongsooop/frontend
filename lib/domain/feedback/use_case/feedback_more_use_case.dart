import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackMoreUseCase {
  final FeedbackRepository repository;

  FeedbackMoreUseCase(this.repository);

  Future<List<String>> execute({
    required FeedbackType type,
    required int page,
    required int size,
  }) {
    switch (type) {
      case FeedbackType.improvement:
        return repository.improvementSuggestions(page: page, size: size);
      case FeedbackType.featureRequest:
        return repository.featureRequests(page: page, size: size);
    }
  }
}