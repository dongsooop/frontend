import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/feedback/data_source/feedback_data_source.dart';
import 'package:dongsoop/data/feedback/model/feedback_list_response.dart';
import 'package:dongsoop/data/feedback/model/feedback_write_request.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';

class FeedbackDataSourceImpl implements FeedbackDataSource {
  final Dio _plainDio;
  final Dio _authDio;

  FeedbackDataSourceImpl(this._plainDio, this._authDio);

  @override
  Future<void> submitFeedback({
    required FeedbackWriteEntity entity,
  }) async {
    final model = FeedbackWriteRequest.fromEntity(entity);
    final url = '/feedback';

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
    final url = '/feedback';
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

  @override
  Future<List<String>> improvementSuggestions() async {
    final url = '/feedback/improvement-suggestions';
    try {
      final response = await _authDio.get(url);
      if (response.statusCode != HttpStatusCode.ok.code) {
        print('[Improvement] 오류 상태 코드: ${response.statusCode}');
        throw Exception('status: ${response.statusCode}');
      }
      final List<dynamic> raw = response.data;
      return raw.map((e) => e.toString()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> featureRequests() async {
    final url = '/feedback/feature-requests';
    try {
      final response = await _authDio.get(url);
      if (response.statusCode != HttpStatusCode.ok.code) {
        throw Exception('status: ${response.statusCode}');
      }
      final List<dynamic> raw = response.data;
      return raw.map((e) => e.toString()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
