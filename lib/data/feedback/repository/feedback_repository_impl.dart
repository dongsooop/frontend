import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/feedback/data_source/feedback_data_source.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackDataSource _dataSource;

  FeedbackRepositoryImpl(this._dataSource);

  @override
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitFeedback(entity: entity);
    }, FeedbackSubmitException());
  }

  @override
  Future<FeedbackListEntity> feedbackList()
  async {
    return _handle(() async {
      final model = await _dataSource.feedbackList();
      return model;
    }, FeedbackException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    }
    catch (_) {
      throw exception;
    }
  }
}