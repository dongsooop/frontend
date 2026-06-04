import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/repository/feeedback_repository.dart';

class FeedbackCsvUseCase {
  final FeedbackRepository repository;

  FeedbackCsvUseCase(this.repository);

  Future<String> execute(FeedbackListEntity data) async {
    final rows = <List<dynamic>>[];

    final totalRespondents = data.improvementSuggestions.length;

    rows.add(['총 응답자 수', totalRespondents]);
    rows.add([]);

    rows.add(['기능명', '선호도']);
    for (final item in data.serviceFeatures) {
      rows.add([item.serviceFeatureName, item.count]);
    }

    rows.add([]);
    rows.add(['개선 의견']);
    for (final item in data.improvementSuggestions) {
      rows.add([item]);
    }

    rows.add([]);
    rows.add(['추가 기능']);
    for (final item in data.featureRequests) {
      rows.add([item]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/feedback_result.csv';

    final file = File(path);
    await file.writeAsString(csv);

    return path;
  }
}