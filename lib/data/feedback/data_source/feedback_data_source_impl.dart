import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/feedback/data_source/feedback_data_source.dart';
import 'package:dongsoop/data/feedback/model/feedback_list_response.dart';
import 'package:dongsoop/data/feedback/model/feedback_write_request.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FeedbackDataSourceImpl implements FeedbackDataSource {
  final Dio _plainDio;

  FeedbackDataSourceImpl(this._plainDio);

  @override
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  }) async {
    final model = FeedbackWriteRequest.fromEntity(entity);
    final url = dotenv.get('FEEDBACK_BASE_ENDPOINT');

    try {
      final response = await _plainDio.post(url, data: model.toJson());

      if (response.statusCode != HttpStatusCode.created.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FeedbackListEntity> feedbackList() async {
    final url = dotenv.get('FEEDBACK_BASE_ENDPOINT');
    try {
      final response = await _plainDio.get(url);
      if (response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }
      final model = FeedbackListResponse.fromJson(response.data);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
