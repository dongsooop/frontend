import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackUseCase {
  final FeedbackRepository repository;

  FeedbackUseCase(this.repository);

  Future<FeedbackListEntity> execute() async {
    return repository.feedbackList();
  }
}