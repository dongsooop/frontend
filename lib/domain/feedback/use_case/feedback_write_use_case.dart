import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackWriteUseCase {
  final FeedbackRepository repository;

  FeedbackWriteUseCase(this.repository);

  Future<void> execute({
    required FeedbackWriteEntity entity,
  }) {
    return repository.submitFeedback(
      entity: entity,
    );
  }
}